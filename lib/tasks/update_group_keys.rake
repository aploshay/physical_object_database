# update_group_keys.rake
# Rake tasks for updating group_keys values
#
# Example use:
# rake pod:update_group_keys[test]
# rake pod:update_group_keys[update]
#
namespace :pod do
  desc "update group keys"
    task :update_group_keys, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      logger = Logger.new(Rails.root.join('log', 'update_group_keys.log'))
      updates = YAML::load_file(Rails.root.join('lib','tasks', 'update_group_keys.yml'))
      logger.info("Update group_keys called in mode: #{mode}")
      updates.each_with_index do |row, index|
        id = row.delete(:id)
        mdpi_barcode = row.delete(:mdpi_barcode)
        if id.to_i.zero? && mdpi_barcode.to_i.zero?
          logger.info("Row #{index}: No id or mdpi_barcode provided")
          next
        end
        atts = row.dup
        po_id = nil
        po_mdpi_barcode = nil
        if id.to_i.positive?
          begin
            po_id = PhysicalObject.find(id)
          rescue ActiveRecord::RecordNotFound
            logger.error("Row #{index}: No record found for id #{id}")
            next
          end
        end
        if mdpi_barcode.to_i.positive?
          po_mdpi_barcode = PhysicalObject.where(mdpi_barcode: mdpi_barcode).first
          if po_mdpi_barcode.nil?
            logger.warn("Row #{index}: No record found for mdpi_barcode #{mdpi_barcode}")
            next
          end
        end
        po = po_id || po_mdpi_barcode
        if po.nil?
          msg += 'NO ACTION: object not found'
          logger.info(msg)
        elsif (id.to_i.positive? && mdpi_barcode.to_i.positive?) && (po_id&.id != po_mdpi_barcode&.id)
          msg = "Row #{index}: #{id} and #{mdpi_barcode} specify different objects!"
          logger.error(msg)
        else
          atts.each do |att, value|
            msg = "id: #{id}, #{mdpi_barcode}: "
            msg += "#{att}: "
            if po.send(att).to_s == value.to_s
              msg += 'NO CHANGE: values match'
              logger.info(msg)
            else
              msg += "UPDATE: --#{value}-- replaces --#{po.send(att)}--"
              po.update_attribute(att, value) if mode == 'update'
              logger.info(msg)
            end
          end
        end
      end
      logger.info("Update group_keys completed.")
    end
end

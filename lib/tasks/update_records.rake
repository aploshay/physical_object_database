# update_records.rake
# Rake tasks for updating records values
#
# Example use:
# rake pod:update_records[test]
# rake pod:update_records[update]
#
namespace :pod do
  desc "update catalog keys"
    task :update_records, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      logger = Logger.new(Rails.root.join('log', 'update_records.log'))
      updates = YAML::load_file(Rails.root.join('lib','tasks', 'update_records.yml'))
      logger.info("Update records called in mode: #{mode}")
      updates.each do |row|
        mdpi_barcode = row.delete(:mdpi_barcode)
        atts = row.dup
        msg = "#{mdpi_barcode}: "
        po = PhysicalObject.where(mdpi_barcode: mdpi_barcode).first
        if po.nil?
          msg += 'NO ACTION: object not found'
          logger.info(msg)
        else
          atts.each do |att, value|
            msg = "#{mdpi_barcode}: "
            msg += "#{att}: "
            if po.send(att).to_s == att.to_s
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
      logger.info("Update records completed.")
    end
end

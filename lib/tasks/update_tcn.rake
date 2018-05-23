# update_tcn.rake
# Rake tasks for updating tcn values
#
# Example use:
# rake pod:update_tcn[test]
# rake pod:update_tcn[update]
#
namespace :pod do
  desc "update title control numbers"
    task :update_tcn, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      logger = Logger.new(Rails.root.join('log', 'update_tcn.log'))
      updates = YAML::load_file(Rails.root.join('lib','tasks', 'condensed_mdpi_tcn.yml'))
      logger.info("Update TCN called in mode: #{mode}")
      updates.each do |row|
        mdpi_barcode = row[:mdpi_barcode]
        title_control_number = row[:title_control_number]
        msg = "#{mdpi_barcode}: "
        po = PhysicalObject.where(mdpi_barcode: mdpi_barcode).first
        if po.nil?
          msg += 'NO ACTION: object not found'
        elsif po.title_control_number == title_control_number
          msg += 'NO CHANGE: title control number values match'
        else
          msg += "UPDATE: --#{title_control_number}-- replaces --#{po.title_control_number}--"
          po.update_attribute(:title_control_number, title_control_number) if mode == 'update'
        end
        logger.info(msg)
      end
    end
end

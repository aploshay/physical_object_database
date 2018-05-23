# update_catkey.rake
# Rake tasks for updating catkey values
#
# Example use:
# rake pod:update_catkey[test]
# rake pod:update_catkey[update]
#
namespace :pod do
  desc "update catalog keys"
    task :update_catkey, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      logger = Logger.new(Rails.root.join('log', 'update_catkey.log'))
      updates = YAML::load_file(Rails.root.join('lib','tasks', 'condensed_mdpi_catkey.yml'))
      logger.info("Update catkey called in mode: #{mode}")
      updates.each do |row|
        mdpi_barcode = row[:mdpi_barcode]
        catalog_key = row[:catalog_key]
        msg = "#{mdpi_barcode}: "
        po = PhysicalObject.where(mdpi_barcode: mdpi_barcode).first
        if po.nil?
          msg += 'NO ACTION: object not found'
        elsif po.catalog_key == catalog_key
          msg += 'NO CHANGE: catalog key values match'
        else
          msg += "UPDATE: --#{catalog_key}-- replaces --#{po.catalog_key}--"
          po.update_attribute(:catalog_key, catalog_key) if mode == 'update'
        end
        logger.info(msg)
      end
    end
end

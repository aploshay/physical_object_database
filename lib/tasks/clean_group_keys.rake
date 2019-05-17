# clean_group_keys.rake
# Rake tasks for updating group_keys values
#
# Example use:
# rake pod:clean_group_keys[test]
# rake pod:clean_group_keys[clean]
#
namespace :pod do
  desc "clean group keys"
    task :clean_group_keys, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      logger = Logger.new(Rails.root.join('log', 'clean_group_keys.log'))
      logger.info("Clean group_keys called in mode: #{mode}")
      GroupKey.includes(:physical_objects).where(physical_objects: { group_key_id: nil }).find_in_batches.with_index do |relation, index|
        logger.info "Index: #{index} -- Object: #{relation.count}"
        relation.map(&:id).each_slice(100) do |ids|
          logger.info("IDs: #{ids}")
          if mode.to_s == 'clean'
            GroupKey.where(id: ids).destroy_all
            logger.info "Set destroyed"
            sleep(1)
          else
            logger.info "Set left alone (called in test mode)"
          end
        end
      end
      logger.info("Clean group_keys completed.")
    end
end

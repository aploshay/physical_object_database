require 'csv'

namespace :pod do
  desc "report unit, format, workflow categories"
    task :report_unit_format_workflow_categories, [:mode] => :environment do |task, args|
      mode = args.mode || 'test'
      headers = ['Unit', 'Format', 'Objects', 'Not started', 'Started', 'Succeeded', 'Failed', 'Rejected']
      formats = ["LP", "Aluminum Disc", "Lacquer Disc", "45", "78", "Other Analog Sound Disc", "Audiocassette", "Betacam", "Betamax", "CD-R", "Cylinder", "DAT", "DV", "DVD", "8mm Video", "Film", "1/2-Inch Open Reel Video Tape", "1-Inch Open Reel Video Tape", "Open Reel Audio Tape", "U-matic", "VHS"]
      CSV.open('log/unit_format_workflow_categories.csv', 'wb') do |csv|
        puts headers.join("\t")
        csv << headers
        Unit.all.each do |unit|
          formats.each do |format|
            row = [unit.abbreviation, format, unit.physical_objects.where(format: format).count]
            (0..4).each { |cat| row << unit.physical_objects.where(format: format, digital_workflow_category: cat).count }
            puts row.join("\t")
            csv << row    
          end
        end
      end
    end
end

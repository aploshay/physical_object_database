class PodReportJob < ActiveJob::Base
  queue_as :default
  attr_reader :search_params, :ws_params

  def perform(search_params, ws_params)
    @search_params = search_params
    @ws_params = ws_params
    pr = PodReport.new(filename: filename, status: "RUNNING")
    pr.save!
    File.write(pr.full_path, report)
    pr.update_attributes!(status: 'Available')
  end

  private
    def filename
      @filename ||= Time.now.to_formatted_s.split(' ')[0,2].join('_').gsub(':', '') + '.xls'
    end

    def report
      @report ||= ApplicationController.new.render_to_string(
                    template: 'search/report.xls',
                    format: 'xls',
                    locals: { :@physical_objects => physical_objects,
                              :@block_metadata => true }
                  )
    end

    def physical_objects
      @full_results = PhysicalObject.physical_object_query(search_params).eager_load(:box, :bin, :box_bin, :box_batch, :bin_batch, :unit, :notes, :condition_statuses, :group_key, :technical_metadatum)
      if ws_params[:workflow_status_template_id] && ws_params[:workflow_status_template_id].any? && !ws_params[:created_at].blank? && !ws_params[:updated_at].blank?
        @full_results = @full_results.workflow_status_search(ws_params[:workflow_status_template_id], ws_params[:created_at], ws_params[:updated_at])
      end
      @full_results
    end
end

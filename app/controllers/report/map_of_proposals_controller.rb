class Report::MapOfProposalsController < Report::BaseController
  report_class MapOfProposalReport, :repository => MapOfProposalSearcher

  def new
    @report = report_instance
    @report.licitation_process_id = params[:licitation_process_id]
  end
end

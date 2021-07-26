class Report::PurchaseSolicitationsController < Report::BaseController
  report_class PurchaseSolicitationReport, :repository => PurchaseSolicitationSearcher

  def new
    @report = report_instance

    unless params[:purchase_solicitation_report] && params[:purchase_solicitation_report][:report_type]
      @report.report_type = ReportType::ANALYTICAL
    end

    @report.valid? if @report.searched?
  end
end

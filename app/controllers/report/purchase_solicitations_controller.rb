class Report::PurchaseSolicitationsController < Report::BaseController
  report_class PurchaseSolicitationReport, :repository => PurchaseSolicitationSearcher

  def new
    @report = report_instance

    unless params[:purchase_solicitation_report]
      @report.start_date = I18n.l Date.current
      @report.end_date = I18n.l Date.current
      @report.type_report = TypeReport::ANALYTICAL
    end
  end
end

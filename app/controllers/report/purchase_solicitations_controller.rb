class Report::PurchaseSolicitationsController < Report::BaseController
  report_class PurchaseSolicitationReport, :repository => PurchaseSolicitationSearcher

  def show
    @report = report_instance

    render :new
  end
end

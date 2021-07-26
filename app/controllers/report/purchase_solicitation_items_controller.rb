class Report::PurchaseSolicitationItemsController < Report::BaseController
  report_class PurchaseSolicitationItemReport, :repository => PurchaseSolicitationItemSearcher
  def show
    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end

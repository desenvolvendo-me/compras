class Report::SupplyOrdersController < Report::BaseController
  report_class SupplyOrderReport

  def show
    @report = report_instance
    @report.supply_order_id = params[:supply_order_id]
    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end

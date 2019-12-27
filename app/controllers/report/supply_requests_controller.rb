class Report::SupplyRequestsController < Report::BaseController
  report_class SupplyRequestReport

  def show
    @report = report_instance
    @report.supply_request_id = params[:supply_request_id]
    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end

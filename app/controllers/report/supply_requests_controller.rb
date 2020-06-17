class Report::SupplyRequestsController < Report::BaseController
  report_class SupplyRequestReport

  def show
    @report = report_instance
    @report.current_user_id = current_user.id
    @report.supply_request_id = params[:supply_request_id]
    if @report.valid?
      render layout: 'report'
    else
      render :news
    end
  end
end

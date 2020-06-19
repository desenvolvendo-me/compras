class Report::SupplyRequestsController < Report::BaseController
  report_class SupplyRequestReport

  def show
    @report = report_instance
    @report.current_user_id = current_user.id
    @report.supply_request_id = params[:supply_request_id]
    @report.approv = params[:approv]
    @report.secretary = Secretary.find(params[:secretary_id]) if params[:secretary_id]

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end

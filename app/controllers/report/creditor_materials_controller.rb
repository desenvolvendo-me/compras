class Report::CreditorMaterialsController < Report::BaseController
  report_class CreditorMaterialReport

  def show
    @report = report_instance
    @report.supply_request_id = params[:supply_request_id]
    @sup_req = SupplyRequest.find(params[:supply_request_id])
    @report.creditor = @sup_req.contract.creditor

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end
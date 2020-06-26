class Report::ContractPerResourceSourcesController < Report::BaseController
  report_class ContractPerResourceSourceReport, :repository => ContractPerResourceSourceSearcher

  def show
    @contract = Contract.find(contract_per_resource_source_params["contract_id"])
    @financials = ContractFinancial.joins(:expense)
        .where(contract_id: contract_per_resource_source_params["contract_id"])
              .where(compras_expenses:{resource_source_id: contract_per_resource_source_params["resource_source_id"]})

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def contract_per_resource_source_params
    params.require(:contract_per_resource_source_report).permit(:contract_id, :resource_source_id)
  end
end
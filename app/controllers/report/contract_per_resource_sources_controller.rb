class Report::ContractPerResourceSourcesController < Report::BaseController
  include Report::ContractPerResourceSourceHelper
  report_class ContractPerResourceSourceReport, :repository => ContractPerResourceSourceSearcher

  def show
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
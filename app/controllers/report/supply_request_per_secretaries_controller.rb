class Report::SupplyRequestPerSecretariesController < Report::BaseController
  report_class SupplyRequestPerSecretaryReport, :repository => SupplyRequestPerSecretarySearcher

  def show
    @supply_requests = SupplyRequest.by_contract( supply_request_per_secretary['contract_id'])
                           .by_material(supply_request_per_secretary['material_id']).by_secretary(supply_request_per_secretary['secretary_id'])

    @secretaries_departments = @supply_requests.map {|s| [s.department&.secretary_id, s.department_id]}.uniq

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def supply_request_per_secretary
    @params = params.require(:supply_request_per_secretary_report).permit(:secretary, :secretary_id, :material, :material_id, :contract, :contract_id)
  end

end

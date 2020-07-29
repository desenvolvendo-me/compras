class Report::ExtractConsumptionPerProcessesController < Report::BaseController
  include Report::BalanceHelper
  include Report::ExtractConsumptionPerProcessHelper

  report_class ExtractConsumptionPerProcessReport, :repository => ExtractConsumptionPerProcessSearcher

  def new
    @report = report_instance

    @report
  end

  def show
    @licitation_processes = get_extract_consumption_per_process

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_extract_consumption_per_process
    @purchase_solicitation = extract_consumption_per_process_report_params['purchase_solicitation_id']
    @licitation_process = extract_consumption_per_process_report_params["licitation_process_id"]
    @contract = extract_consumption_per_process_report_params["contract_id"]
    @creditor = extract_consumption_per_process_report_params["creditor_id"]

    @licitation_processes = LicitationProcess.joins(contracts: [:creditor]).joins(:purchase_solicitations)
    @licitation_processes = @licitation_processes.where('compras_list_purchase_solicitation.purchase_solicitation_id = ?', @purchase_solicitation) if @purchase_solicitation.present?
    @licitation_processes = @licitation_processes.where(id: @licitation_process) if @licitation_process.present?
    @licitation_processes = @licitation_processes.where("compras_contracts.id = #{@contract}") if @contract.present?
    @licitation_processes = @licitation_processes.where("compras_contracts.creditor_id = #{@creditor}") if @creditor.present?
    @licitation_processes
  end

  def extract_consumption_per_process_report_params
    @params = params.require(:extract_consumption_per_process_report).permit(:licitation_process_id, :creditor_id, :contract_id)
  end
end

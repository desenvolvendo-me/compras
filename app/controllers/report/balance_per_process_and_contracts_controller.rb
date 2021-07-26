class Report::BalancePerProcessAndContractsController < Report::BaseController
  include Report::BalanceHelper
  include Report::BalancePerProcessAndContractHelper

  report_class BalancePerProcessAndContractReport, :repository => BalancePerProcessAndContractSearcher

  def show
    @licitation_processes = get_balance_per_process_and_contract

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_balance_per_process_and_contract
    @licitation_process = balance_per_process_and_contract_report_params["licitation_process_id"]
    @contract = balance_per_process_and_contract_report_params["contract_id"]
    @creditor = balance_per_process_and_contract_report_params["creditor_id"]

    @licitation_processes = LicitationProcess.joins(contracts: [:creditor])
    @licitation_processes = @licitation_processes.where(id: @licitation_process) if @licitation_process.present?
    @licitation_processes = @licitation_processes.where("compras_contracts.id = #{@contract}") if @contract.present?
    @licitation_processes = @licitation_processes.where("compras_contracts.creditor_id = #{@creditor}") if @creditor.present?
    @licitation_processes
  end

  def balance_per_process_and_contract_report_params
    @params = params.require(:balance_per_process_and_contract_report).permit(:licitation_process_id, :creditor_id, :contract_id)
  end
end

class Report::BalancePerProcessAndContractController < Report::BaseController
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

    @licitation_processes = LicitationProcess.
        where(id: balance_per_process_and_contract_report_params["licitation_process_id"])
  end

  def balance_per_process_and_contract_report_params
    @params = params.require(:balance_per_process_and_contract_report).permit(:licitation_process_id, :creditor_id, :contract_id)
  end
end

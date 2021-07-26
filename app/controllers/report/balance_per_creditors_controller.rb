class Report::BalancePerCreditorsController < Report::BaseController
  report_class BalancePerCreditorReport, :repository => BalancePerCreditorSearcher

  def show
    @creditors = get_balance_per_creditor

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_balance_per_creditor
    @creditor = balance_per_creditor_report_params["creditor_id"]
    @licitation_process = balance_per_creditor_report_params["licitation_process_id"]
    @contracts = Contract.where(creditor_id:@creditor)
    @contracts = @contracts.where(licitation_process_id:@licitation_process) unless @licitation_process.empty?
  end

  def balance_per_creditor_report_params
    @params = params.require(:balance_per_creditor_report).permit(:licitation_process_id, :creditor_id, :department_id)
  end

end

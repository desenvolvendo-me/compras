class Report::BalancePerCreditorController < Report::BaseController
  report_class BalancePerCreditorReport, :repository => BalancePerCreditorSearcher

  def show
    @licitation_processes = get_balance_per_creditor

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_balance_per_creditor

    @licitation_processes = LicitationProcess.
        where(balance_per_creditor_report_params.except!(:creditor_id))
  end

  def balance_per_creditor_report_params
    @params = params.require(:balance_per_creditor_report).permit(:process, :creditor_id)
  end
end

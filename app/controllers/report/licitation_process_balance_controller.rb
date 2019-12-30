class Report::LicitationProcessBalanceController < Report::BaseController
  report_class LicitationProcessBalanceReport, :repository => LicitationProcessBalanceSearcher

  def show
    @licitation_processes = get_licitation_process_balance

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_licitation_process_balance

    @licitation_processes = LicitationProcess.
        where(licitation_process_balance_report_params.except!(:creditor_id))
  end

  def licitation_process_balance_report_params
    @params = params.require(:licitation_process_balance_report).permit(:process, :creditor_id)
  end
end

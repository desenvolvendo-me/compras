class Report::BalancePerCreditorController < Report::BaseController
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
    @creditors = Creditor.joins(:contracts).
        where(id: balance_per_creditor_report_params["creditor_id"]).where("compras_contracts.licitation_process_id = #{balance_per_creditor_report_params["licitation_process_id"]}")
  end

  def balance_per_creditor_report_params
    @params = params.require(:balance_per_creditor_report).permit(:licitation_process_id, :creditor_id)
  end
end

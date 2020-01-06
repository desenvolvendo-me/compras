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
    @creditor = balance_per_creditor_report_params["creditor_id"]
    @licitation_process = balance_per_creditor_report_params["licitation_process_id"]
    @department = balance_per_creditor_report_params["department_id"]

    @creditors = Creditor.joins(contracts: [licitation_process: [purchase_solicitations: [purchase_solicitation: :department]]])
    @creditors = @creditors.where(id: @creditor) if @creditor.present?
    @creditors = @creditors.where("compras_contracts.licitation_process_id = #{@licitation_process}") if @licitation_process.present?
    @creditors = @creditors.where("compras_departments.id = #{@department}") if @department.present?
    @creditors
  end

  def balance_per_creditor_report_params
    @params = params.require(:balance_per_creditor_report).permit(:licitation_process_id, :creditor_id, :department_id)
  end
end

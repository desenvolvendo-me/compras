class Report::BalancePerProcessAndSuppliersController < Report::BaseController

  report_class BalancePerProcessAndSupplierReport, :repository => BalancePerProcessAndSupplierSearcher

  def show
    @creditors = get_balance_per_process_and_supplier

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_balance_per_process_and_supplier
    @creditor = balance_per_process_and_supplier_report_params["creditor_id"]
    @licitation_process = balance_per_process_and_supplier_report_params["licitation_process_id"]
    @contracts = Contract.joins(:creditors).
        where(compras_contracts_unico_creditors:{creditor_id:@creditor})
    @contracts = @contracts.where(licitation_process_id:@licitation_process) unless @licitation_process.empty?
  end

  def balance_per_process_and_supplier_report_params
    @params = params.require(:balance_per_process_and_supplier_report).permit(:licitation_process_id, :creditor_id)
  end

end

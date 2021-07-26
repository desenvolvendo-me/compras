class Report::SupplierBalancePerServiceOrdersController < Report::BaseController

  report_class SupplierBalancePerServiceOrderReport, :repository => SupplierBalancePerServiceOrderSearcher

  def show
    @creditors = get_supplier_balance_per_service_order

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_supplier_balance_per_service_order
    @creditor = supplier_balance_per_service_order_report_params["creditor_id"]
    @licitation_process = supplier_balance_per_service_order_report_params["licitation_process_id"]
    @supply_order = supplier_balance_per_service_order_report_params["supply_order_id"]
    @contracts = get_contracts @creditor
    @contracts = @contracts.where(licitation_process_id:@licitation_process) unless @licitation_process.nil?
  end

  def get_contracts(creditor)
    if creditor.nil?
      Contract.joins(:creditor).where(unico_creditors:{id:creditor})
    else
      Contract.joins(:creditor)
    end
  end

  def supplier_balance_per_service_order_report_params
    @params = params.require(:supplier_balance_per_service_order_report).permit(:licitation_process_id, :creditor_id, :supply_order_id)
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:supply_order_id) if params[:supply_order_id].blank?
    params.delete(:licitation_process_id) if params[:licitation_process_id].blank?
    params
  end

end

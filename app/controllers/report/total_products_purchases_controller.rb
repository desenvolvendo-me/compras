class Report::TotalProductsPurchasesController < Report::BaseController
  report_class TotalProductsPurchaseReport, :repository => TotalProductsPurchaseSearcher

  def show
    @licitation_processes = get_total_products_purchase

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_total_products_purchase
    @creditor = total_products_purchase_report_params["creditor_id"]
    @material = total_products_purchase_report_params["material_id"]

    @creditors = Creditor.joins(:contracts, licitation_process_ratification_items: :purchase_process_item)
    @creditors = @creditors.where(id: @creditor) if @creditor.present?
    @creditors = @creditors.where("compras_purchase_process_items.material_id = #{@material}") if @material.present?
    @creditors
  end

  def total_products_purchase_report_params
    @params = params.require(:total_products_purchase_report).permit(:material_id, :creditor_id)
  end
end

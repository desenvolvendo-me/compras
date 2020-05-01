class Report::TotalPurchasePerElementAndNaturesController < Report::BaseController
  report_class TotalPurchasePerElementAndNatureReport, :repository => TotalPurchasePerElementAndNatureSearcher

  def show
    @licitation_processes = get_total_purchase_per_element_and_nature

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_total_purchase_per_element_and_nature
    nature_expense_id = total_purchase_per_element_and_nature_report_params["nature_expense_id"]
    @materiais = Material.joins(purchase_solicitation_items: [purchase_solicitation: [purchase_forms: [purchase_form: [expense: :nature_expense]]]])
    @materiais = @materiais.where("compras_expenses.nature_expense_id = #{nature_expense_id}") if nature_expense_id.present?
    @materiais
  end

  def total_purchase_per_element_and_nature_report_params
    @params = params.require(:total_purchase_per_element_and_nature_report).permit(:nature_expense_id)
  end
end

module Report::TotalPurchasePerElementAndNatureHelper

  def self.get_expense(material)
    expense = ""
    purchase_solicitation_items = material.purchase_solicitation_items
    if material.purchase_solicitation_items.present?
      purchase_forms = purchase_solicitation_items.first.purchase_solicitation.purchase_forms
      if purchase_forms.present?
        expense = purchase_forms.first.purchase_form.expense.nature_expense
      end
    end
    expense
  end
end
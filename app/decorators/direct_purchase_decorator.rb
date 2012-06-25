# encoding: utf-8
class DirectPurchaseDecorator < Decorator
  attr_modal :year, :date, :modality

  def total_allocations_items_value
    helpers.number_with_precision component.total_allocations_items_value
  end

  def summary
    "Estrutura orçamentaria: #{budget_structure} / Fornecedor: #{creditor}"
  end
end

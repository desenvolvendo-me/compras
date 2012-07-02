# encoding: utf-8
class DirectPurchaseDecorator < Decorator
  attr_modal :year, :date, :modality

  def total_allocations_items_value
    helpers.number_with_precision super
  end

  def summary
    "Estrutura orçamentaria: #{budget_structure} / Fornecedor: #{creditor}"
  end
end

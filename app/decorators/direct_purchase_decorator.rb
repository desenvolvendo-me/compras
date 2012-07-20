# encoding: utf-8
class DirectPurchaseDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def total_allocations_items_value
    number_with_precision super if super
  end

  def summary
    "Estrutura orçamentaria: #{budget_structure} / Fornecedor: #{creditor}"
  end
end

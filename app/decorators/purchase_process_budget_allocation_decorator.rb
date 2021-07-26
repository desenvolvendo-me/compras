class PurchaseProcessBudgetAllocationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def budget_allocation_balance
    number_with_precision super if super
  end

  def value
    number_with_precision super if super
  end

  def total_items_value
    number_with_precision super if super
  end
end

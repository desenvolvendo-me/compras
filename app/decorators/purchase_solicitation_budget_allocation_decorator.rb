class PurchaseSolicitationBudgetAllocationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def estimated_value
    number_with_precision super if super
  end

  def budget_allocation_balance
    number_with_precision super if super
  end
end

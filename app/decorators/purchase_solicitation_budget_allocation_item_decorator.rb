class PurchaseSolicitationBudgetAllocationItemDecorator < Decorator
  def estimated_total_price
    helpers.number_with_precision super
  end
end

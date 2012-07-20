class PurchaseSolicitationBudgetAllocationItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def estimated_total_price
    number_with_precision super
  end
end

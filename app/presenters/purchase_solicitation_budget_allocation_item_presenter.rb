class PurchaseSolicitationBudgetAllocationItemPresenter < Presenter::Proxy
  def estimated_total_price
    helpers.number_with_precision(object.estimated_total_price)
  end
end

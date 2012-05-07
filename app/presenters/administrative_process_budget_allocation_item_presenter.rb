class AdministrativeProcessBudgetAllocationItemPresenter < Presenter::Proxy
  attr_modal :material, :quantity, :unit_price

  attr_data 'id' => :id, 'material' => :material, 'quantity' => :quantity, 'unit_price' => :unit_price
end

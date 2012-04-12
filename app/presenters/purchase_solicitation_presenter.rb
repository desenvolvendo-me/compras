class PurchaseSolicitationPresenter < Presenter::Proxy
  attr_modal :accounting_year, :kind, :delivery_location_id, :budget_unit_id
end

class PurchaseForm < Compras::Model
  attr_accessible :budget_allocation, :number

  attr_modal :budget_allocation, :number

  orderize
  filterize
end

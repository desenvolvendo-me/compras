class PurchaseForm < Compras::Model
  attr_accessible :budget_allocation, :name

  orderize
  filterize

  validates :name,:budget_allocation,presence:true
end

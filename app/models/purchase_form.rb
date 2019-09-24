class PurchaseForm < Compras::Model
  attr_accessible :budget_allocation, :name

  orderize
  filterize

  validates :name,:budget_allocation,presence:true

  def to_s
    "#{name} - #{budget_allocation }"
  end

end

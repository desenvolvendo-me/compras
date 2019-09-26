class PurchaseForm < Compras::Model
  attr_accessible :budget_allocation, :name,:opening_balance

  orderize
  filterize

  validates :name,:budget_allocation, presence:true

  def to_s
    "#{name} - #{budget_allocation }"
  end

end

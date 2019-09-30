class SplitExpense < Compras::Model
  belongs_to :nature_expense
  attr_accessible :code, :description, :function_account

  validates :code,:description,presence: true

  orderize :id
  filterize
end

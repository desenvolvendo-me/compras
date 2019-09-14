class SplitExpense < Compras::Model
  belongs_to :nature_expense
  attr_accessible :code, :description, :function_account

  validates_format_of :code, :with => /^[0-9.&]*\z/

  orderize :id
  filterize
end

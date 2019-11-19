class ExpenseFunction < Compras::Model
  attr_accessible :code, :name

  validates :code, :name, presence: true

  orderize "created_at"
  filterize

  def to_s
    name
  end

end

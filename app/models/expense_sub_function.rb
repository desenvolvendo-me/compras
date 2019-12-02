class ExpenseSubFunction < Compras::Model
  attr_accessible :code, :name

  validates :code, :name, presence: true, uniqueness: true

  orderize "created_at"
  filterize

  def to_s
    "#{code}"
  end

end

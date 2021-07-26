class ExpenseFunction < Compras::Model
  attr_accessible :code, :name

  validates :code, :name, presence: true
  validates :code, uniqueness: true

  orderize "created_at"
  filterize

  def to_s
    "#{code}"
  end

end

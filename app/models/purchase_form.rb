class PurchaseForm < Compras::Model
  belongs_to :expense

  attr_accessible :name,:expense_id

  orderize
  filterize

  validates :name, presence:true

  def to_s
    "#{name}"
  end

end

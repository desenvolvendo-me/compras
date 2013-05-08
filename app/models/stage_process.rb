class StageProcess < Compras::Model
  attr_accessible :description, :type_of_purchase

  has_enumeration_for :type_of_purchase, :with => PurchaseProcessTypeOfPurchase, :create_helpers => true

  validates :description, presence: true

  orderize :description
  filterize

  def to_s
    "#{description}"
  end
end

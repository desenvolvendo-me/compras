class StageProcess < Compras::Model
  attr_accessible :description, :type_of_purchase

  has_enumeration_for :type_of_purchase, :with => PurchaseProcessTypeOfPurchase,
                      :create_helpers => true, :create_scopes => true

  has_many :process_responsibles, :dependent => :restrict

  orderize :description
  filterize

  def to_s
    "#{description}"
  end
end

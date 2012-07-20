class DeliveryLocation < Compras::Model
  attr_accessible :address_attributes, :description

  attr_modal :description

  belongs_to :address

  has_many :purchase_solicitations, :dependent => :restrict
  has_many :direct_purchases, :dependent => :restrict
  has_many :price_collections, :dependent => :restrict

  validates :address, :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  accepts_nested_attributes_for :address

  orderize :description
  filterize

  def to_s
    description
  end
end

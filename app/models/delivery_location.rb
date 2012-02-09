class DeliveryLocation < ActiveRecord::Base
  attr_accessible :address_attributes, :description

  attr_modal :description

  belongs_to :address
  has_many :purchase_solicitations

  accepts_nested_attributes_for :address

  validates :address, :description, :presence => true
  validates :description, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end

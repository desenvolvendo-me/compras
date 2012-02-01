class DeliveryLocation < ActiveRecord::Base
  attr_accessible :address_attributes, :name

  attr_modal :name

  belongs_to :address
  has_many :purchase_solicitations

  accepts_nested_attributes_for :address

  validates :address, :name, :presence => true
  validates :name, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end

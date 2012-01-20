class DeliveryLocation < ActiveRecord::Base
  attr_accessible :address_attributes, :name

  belongs_to :address

  accepts_nested_attributes_for :address

  validates :address, :name, :presence => true
  validates :name, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end

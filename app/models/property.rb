class Property < ActiveRecord::Base
  attr_accessible :property_registration, :owner_id

  attr_modal :property_registration, :owner

  has_many :owners, :dependent => :restrict
  has_many :providers, :dependent => :restrict

  orderize :owner_id
  filterize

  def owner
    owners.first.person if owners.first
  end

  def to_s
    property_registration
  end
end

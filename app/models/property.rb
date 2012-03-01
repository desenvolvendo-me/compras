class Property < ActiveRecord::Base
  attr_readonly :property_registration

  attr_modal :property_registration

  has_many :owners, :dependent => :restrict

  delegate :id, :to => :owner, :prefix => true, :allow_nil => true

  orderize :property_registration
  filterize

  def owner
    owners.first.person if owners.first
  end

  def to_s
    property_registration
  end
end

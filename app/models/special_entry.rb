class SpecialEntry < ActiveRecord::Base
  attr_accessible :person_attributes
  attr_accessible :address_attributes
  attr_accessible :correspondence_address_attributes

  has_one :address, :as => :addressable, :conditions => { :correspondence => false }, :dependent => :destroy
  has_one :correspondence_address, :as => :addressable, :conditions => { :correspondence => true }, :class_name => 'Address', :dependent => :destroy
  has_one :person, :as => :personable, :dependent => :restrict

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :correspondence_address
  accepts_nested_attributes_for :person

  delegate :to_s, :to => :person, :allow_nil => true

  filterize
  orderize :id
end

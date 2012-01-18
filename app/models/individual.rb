class Individual < ActiveRecord::Base
  attr_accessible :person_attributes, :mother, :father, :birthdate, :gender
  attr_accessible :identity_attributes, :address_attributes, :cpf
  attr_accessible :correspondence_address_attributes

  has_enumeration_for :gender

  has_one :address, :as => :addressable, :conditions => { :correspondence => false }, :dependent => :destroy
  has_one :correspondence_address, :as => :addressable, :conditions => { :correspondence => true }, :class_name => 'Address', :dependent => :destroy
  has_one :identity, :dependent => :destroy
  has_one :person, :as => :personable, :dependent => :restrict

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :correspondence_address
  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :identity

  validates :cpf, :mother, :birthdate, :gender, :address, :identity, :presence => true
  validates :cpf, :cpf => true, :mask => '999.999.999-99', :uniqueness => true, :allow_blank => true
  validates :birthdate, :timeliness => { :before => :today, :type => :date }, :allow_blank => true

  filterize
  orderize

  def to_s
    person.name
  end
end

class Company < ActiveRecord::Base
  attr_accessible :name, :cnpj, :person_id, :legal_nature_id, :company_size_id
  attr_accessible :state_registration, :commercial_registration_number
  attr_accessible :commercial_registration_date, :responsible_role
  attr_accessible :address_attributes, :correspondence_address_attributes
  attr_accessible :person_attributes, :choose_simple

  belongs_to :legal_nature
  belongs_to :responsible, :class_name => 'Person', :foreign_key => 'person_id'
  belongs_to :company_size

  has_one :address, :as => :addressable, :conditions => { :correspondence => false }, :dependent => :destroy
  has_one :correspondence_address, :as => :addressable, :conditions => { :correspondence => true }, :class_name => 'Address', :dependent => :destroy
  has_one :person, :as => :personable, :dependent => :restrict

  validates :cnpj, :cnpj => true, :uniqueness => true, :mask => '99.999.999/9999-99'
  validates :cnpj, :company_size, :address, :presence => true
  validates :responsible_role, :legal_nature, :responsible, :presence => true

  filterize
  orderize

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :correspondence_address
  accepts_nested_attributes_for :person

  def to_s
    person.name
  end
end

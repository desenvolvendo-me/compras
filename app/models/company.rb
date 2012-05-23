class Company < ActiveRecord::Base
  attr_accessible :name, :cnpj, :person_id, :legal_nature_id, :company_size_id
  attr_accessible :state_registration, :commercial_registration_number
  attr_accessible :commercial_registration_date, :responsible_role
  attr_accessible :address_attributes, :correspondence_address_attributes
  attr_accessible :person_attributes, :choose_simple, :partners_attributes

  belongs_to :legal_nature
  belongs_to :responsible, :class_name => 'Person', :foreign_key => 'person_id'
  belongs_to :company_size

  has_one :address, :as => :addressable, :conditions => { :correspondence => false }, :dependent => :destroy
  has_one :correspondence_address, :as => :addressable, :conditions => { :correspondence => true }, :class_name => 'Address', :dependent => :destroy
  has_one :person, :as => :personable, :dependent => :restrict
  has_many :partners, :dependent => :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :correspondence_address
  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :partners, :allow_destroy => true

  validates :cnpj, :cnpj => true, :uniqueness => true, :mask => '99.999.999/9999-99', :allow_blank => true
  validates :cnpj, :company_size, :address, :presence => true
  validates :responsible_role, :legal_nature, :responsible, :presence => true
  validate  :at_least_one_partner
  validate  :hundred_percent_for_partners
  validate  :uniqueness_of_person

  orderize
  filterize

  def to_s
    person.name
  end

  protected

  def hundred_percent_for_partners
    return if partners.reject(&:marked_for_destruction?).map(&:percentage).compact.sum == 100

    # FIXME: rails issue, see: https://github.com/rails/rails/issues/5061
    errors.add(:partners, :hundred_percent)
  end

  def uniqueness_of_person
    countable = Hash.new

    partners.each do |partner|
      if partner.person_id.blank?
        partner.errors.add(:person_id, :blank)
      else
        countable[partner.person_id] ||= 0
        countable[partner.person_id] = countable[partner.person_id].to_i + 1
      end
    end

    partners.each do |partner|
      if countable[partner.person_id].to_i > 1
        # FIXME: rails issue, see: https://github.com/rails/rails/issues/5061
        errors.add(:partners, :invalid)

        partner.errors.add(:person_id, :taken)
      end
    end
  end

  def at_least_one_partner
    errors.add(:partners, :at_least_one_partner) if partners.empty?
  end
end

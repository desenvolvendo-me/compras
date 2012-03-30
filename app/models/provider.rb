class Provider < ActiveRecord::Base
  attr_accessible :person_id, :agency_id, :legal_nature_id, :cnae_id, :registration_date
  attr_accessible :bank_account, :crc_number, :crc_registration_date, :crc_expiration_date
  attr_accessible :crc_renewal_date, :provider_partners_attributes, :economic_registration_id
  attr_accessible :materials_group_ids, :materials_class_ids, :material_ids
  attr_accessible :provider_licitation_documents_attributes

  attr_modal :economic_registration_id, :person_id, :legal_nature_id, :cnae_id, :crc_number

  belongs_to :person
  belongs_to :economic_registration
  belongs_to :agency
  belongs_to :legal_nature
  belongs_to :cnae

  has_and_belongs_to_many :materials_groups
  has_and_belongs_to_many :materials_classes
  has_and_belongs_to_many :materials

  has_many :provider_partners, :dependent => :destroy, :order => :id
  has_many :provider_licitation_documents, :dependent => :destroy, :inverse_of => :provider, :order => :id
  has_many :direct_purchases, :dependent => :restrict
  has_many :licitation_process_invited_bidders, :dependent => :restrict

  accepts_nested_attributes_for :provider_partners, :allow_destroy => true
  accepts_nested_attributes_for :provider_licitation_documents, :allow_destroy => true

  delegate :bank, :bank_id, :to => :agency, :allow_nil => true
  delegate :personable_type, :phone, :fax, :to => :person, :allow_nil => true
  delegate :address, :city, :zip_code, :to => :person, :allow_nil => true

  validates :person, :registration_date, :agency, :bank_account, :presence => true
  validates :legal_nature, :cnae, :presence => true

  validate :cannot_have_duplicated_partners
  validate :must_have_at_least_one_partner

  before_save :clean_extra_partners

  orderize :person_id
  filterize

  def to_s
    person.to_s
  end

  protected

  def cannot_have_duplicated_partners
    single_individuals = []

    provider_partners.each do |partner|
      if single_individuals.include?(partner.individual_id)
        errors.add(:provider_partners)
        partner.errors.add(:individual_id, :taken)
      end
      single_individuals << partner.individual_id
    end
  end

  def must_have_at_least_one_partner
    return unless company? && provider_partners.empty?

    errors.add(:provider_partners, :must_have_at_least_one_partner)
  end

  def clean_extra_partners
    return if company?

    provider_partners.each(&:destroy)
  end

  def company?
    person && person.personable.class == Company
  end
end

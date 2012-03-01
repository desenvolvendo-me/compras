class Provider < ActiveRecord::Base
  attr_accessible :person_id, :agency_id, :legal_nature_id, :cnae_id, :registration_date
  attr_accessible :bank_account, :crc_number, :crc_registration_date, :crc_expiration_date, :crc_renewal_date
  attr_accessible :provider_partners_attributes, :economic_registration_id

  belongs_to :person
  belongs_to :economic_registration
  belongs_to :agency
  belongs_to :legal_nature
  belongs_to :cnae

  has_many :provider_partners, :dependent => :destroy

  delegate :bank, :bank_id, :to => :agency, :allow_nil => true
  delegate :personable_type, :to => :person, :allow_nil => true

  validates :person, :presence => true

  validate :cannot_have_duplicated_partners

  orderize :person_id
  filterize

  accepts_nested_attributes_for :provider_partners, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    id.to_s
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
end

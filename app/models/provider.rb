class Provider < ActiveRecord::Base
  attr_accessible :person_id, :property_id, :agency_id, :legal_nature_id, :cnae_id, :registration_date
  attr_accessible :bank_account, :crc_number, :crc_registration_date, :crc_expiration_date, :crc_renewal_date

  belongs_to :person
  belongs_to :property
  belongs_to :agency
  belongs_to :legal_nature
  belongs_to :cnae

  delegate :bank, :bank_id, :to => :agency, :allow_nil => true

  validates :person, :presence => true

  orderize :person_id
  filterize

  def to_s
    id.to_s
  end
end

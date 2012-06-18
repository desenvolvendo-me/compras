class Individual < Unico::Individual
  has_many :provider_partners, :dependent => :restrict
  has_many :licitation_commission_responsibles, :dependent => :restrict
  has_many :licitation_commission_members, :dependent => :restrict
  has_many :judgment_commission_advice_members, :dependent => :restrict

  validates :mother, :birthdate, :identity, :presence => true

  delegate :to_s, :to => :person, :allow_nil => true
  delegate :city, :zip_code, :to => :address, :allow_nil => true

  filterize
  orderize :birthdate
end

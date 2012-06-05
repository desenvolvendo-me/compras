class LegalNature < Unico::LegalNature
  has_enumeration_for :level_of_nature, :with => LevelOfLegalNature

  has_many :administration_types, :dependent => :restrict
  has_many :providers, :dependent => :restrict

  filterize
  orderize :created_at
end

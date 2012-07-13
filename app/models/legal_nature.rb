class LegalNature < Unico::LegalNature
  has_many :administration_types, :dependent => :restrict

  filterize
  orderize :created_at
end

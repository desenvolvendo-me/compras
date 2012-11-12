class LegalNature < Persona::LegalNature
  attr_modal :code, :name

  has_many :administration_types, :dependent => :restrict

  filterize
  orderize :created_at
end

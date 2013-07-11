class LegalNature < Persona::LegalNature
  attr_modal :code, :name

  filterize
  orderize :created_at
end

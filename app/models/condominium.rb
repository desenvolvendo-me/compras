class Condominium < InscriptioCursualis::Condominium
  attr_accessible  :name, :condominium_type
  filterize
  orderize
end

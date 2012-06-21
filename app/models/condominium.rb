class Condominium < Unico::Condominium
  has_enumeration_for :condominium_type

  filterize
  orderize
end

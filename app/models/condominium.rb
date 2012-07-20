class Condominium < Unico::Condominium
  attr_modal :name, :condominium_type

  has_enumeration_for :condominium_type

  filterize
  orderize
end

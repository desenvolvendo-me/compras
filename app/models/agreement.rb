class Agreement < Compras::Model
  attr_modal :description, :process_date, :regulatory_act_id, :category

  has_enumeration_for :category, :with => AgreementCategory

  orderize :description
  filterize
end

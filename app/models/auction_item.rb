class AuctionItem < Compras::Model
  attr_accessible :purchase_solicitation_id,:material_id, :reference_unit_id, :description,
                  :detailed_description, :estimated_value, :max_value , :benefit_type,

  belongs_to :purchase_solicitation
  belongs_to :material
  belongs_to :reference_unit

  has_enumeration_for :benefit_type, :with => BenefitType

  orderize :id
  filterize
end

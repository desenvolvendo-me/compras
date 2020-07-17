class AuctionItem < Compras::Model
  attr_accessible :purchase_solicitation_item_id,:material_id, :reference_unit_id, :description, :lot,
                  :detailed_description, :estimated_value, :max_value , :benefit_type, :auction_id

  belongs_to :auction
  belongs_to :purchase_solicitation_item
  belongs_to :material
  belongs_to :reference_unit

  has_enumeration_for :benefit_type, :with => BenefitType

  orderize :id
  filterize
end

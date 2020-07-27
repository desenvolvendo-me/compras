class AuctionItem < Compras::Model
  attr_accessible :material_id, :reference_unit_id, :description, :group_lot, :quantity,
                  :detailed_description, :estimated_value, :max_value , :benefit_type, :auction_id

  belongs_to :auction
  belongs_to :material

  has_one :reference_unit, through: :material
  has_one :material_class, through: :material

  has_enumeration_for :benefit_type, :with => BenefitType

  orderize :id
  filterize

  scope :by_group_lot, lambda{
    select('COUNT(*) as quantity, group_lot').group(:group_lot)
  }
end
class AuctionGroupItem < Compras::Model
  attr_accessible :auction_id, :purchase_type, :group_form, :group, :quantity, :judment_form, :total_value, :max_value, :benefit_type

  belongs_to :auction

  has_enumeration_for :benefit_type, :with => BenefitType
  has_enumeration_for :group_form, :with => AuctionGroupForm
  has_enumeration_for :judment_form, :with => AuctionJudmentForm
  has_enumeration_for :purchase_type, :with => AuctionPurchaseType
end

class Auction < Compras::Model
  attr_modal :auction_type,:licitation_number,:process_number,:year,:dispute_type,
             :judment_form,:covid_law,:purchase_value,:items_quantity,
             :object,:object_management,:employee_id

  belongs_to :employee

  has_enumeration_for :auction_type, :with => AuctionType
  has_enumeration_for :dispute_type, :with => AuctionDisputeType
  has_enumeration_for :judment_form, :with => AuctionJudmentForm

  orderize :description
  filterize
end

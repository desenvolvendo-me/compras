class AuctionDisputeItemBid < Compras::Model
  attr_accessible :auction_dispute_item_id, :creditor_id, :amount

  belongs_to :auction_dispute_item
  belongs_to :creditor

  delegate :status_humanize, to: :auction_dispute_item, allow_nil: true

  scope :bids_ordered_by_item, lambda{|item_id|
    where(auction_dispute_item_id: item_id).order(:amount)
  }
end

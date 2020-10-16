class AuctionDisputItemBid < Compras::Model
  attr_accessible :auction_disput_item_id, :creditor_id, :amount

  belongs_to :auction_disput_item
  belongs_to :creditor

  delegate :status_humanize, to: :auction_disput_item, allow_nil: true

  scope :bids_ordered_by_item, lambda{|item_id|
    where(auction_disput_item_id: item_id).order(:amount)
  }
end

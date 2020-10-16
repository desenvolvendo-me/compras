class AuctionDisputItem < Compras::Model
  attr_accessible :auction_id, :auction_item_id, :status

  belongs_to :auction
  belongs_to :auction_item

  has_one :material, :through => :auction_item

  has_many :bids, class_name: 'AuctionDisputItemBid'

  has_enumeration_for :status, with: AuctionDisputItemStatus,
                      create_helpers: true, create_scopes: true

  def lowest_item_proposal
    auction.auction_creditor_proposal_items.proposals_ordered_by_item(id).first
  end

  def lowest_bid
    bids.bids_ordered_by_item(id).first
  end
end

class AuctionDisputItem < Compras::Model
  attr_accessible :auction_id, :auction_item_id, :status

  belongs_to :auction
  belongs_to :auction_item

  has_enumeration_for :status, with: AuctionDisputItemStatus,
                      create_helpers: true, create_scopes: true

  def lowest_item_proposal_amount
    auction.auction_creditor_proposal_items.lowest_proposal_by_item(id).first
  end
end

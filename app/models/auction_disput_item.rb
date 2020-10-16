class AuctionDisputItem < Compras::Model
  attr_accessible :auction_id, :auction_item_id, :status

  belongs_to :auction
  belongs_to :auction_item

  has_enumeration_for :status, with: AuctionDisputItemStatus,
                      create_helpers: true, create_scopes: true
end

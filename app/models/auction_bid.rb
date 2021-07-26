class AuctionBid < Compras::Model
  attr_modal :auction_id, :lot, :status

  has_enumeration_for :status, with: PurchaseProcessTradingItemStatus,
                      create_helpers: true, create_scopes: true

  orderize :lot
end

class AuctionBid < Compras::Model
  attr_modal :auction_id, :creditor_id, :lot

  orderize :lot
end

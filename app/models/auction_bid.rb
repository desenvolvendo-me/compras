class AuctionBid < Compras::Model
  attr_modal :auction_id, :lot

  orderize :lot
end

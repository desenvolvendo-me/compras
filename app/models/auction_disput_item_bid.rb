class AuctionDisputItemBid < Compras::Model
  attr_accessible :auction_disput_item_id, :creditor_id, :amount

  belongs_to :auction_disput_item
  belongs_to :creditor

end

class AuctionChat < Compras::Model
  attr_accessible :auction_id, :is_enabled

  belongs_to :auction
  has_many :auction_chat_messages
end
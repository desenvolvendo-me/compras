class AuctionChatMessage < Compras::Model
  attr_accessible :auction_chat_id, :sender_id, :message

  belongs_to :auction_chat
  belongs_to :sender, class_name: 'User'
end
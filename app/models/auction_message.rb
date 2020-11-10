class AuctionMessage < Compras::Model
  attr_accessible :auction_conversation_id, :sender_id, :body

  belongs_to :auction_conversation
  belongs_to :sender, class_name: 'User'

  validates :sender, :auction_conversation, presence: true
end
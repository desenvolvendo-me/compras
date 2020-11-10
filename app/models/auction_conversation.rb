class AuctionConversation < Compras::Model
  attr_accessible :auction_id, :is_enabled

  belongs_to :auction
  has_many :messages, class_name:'AuctionMessage', dependent: :destroy

  validates :auction, :is_enabled, presence: true
end
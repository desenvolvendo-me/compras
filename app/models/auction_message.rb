class AuctionMessage < Compras::Model
  attr_accessible :auction_conversation_id, :sender_id, :body

  belongs_to :auction_conversation
  belongs_to :sender, class_name: 'User'

  has_one :authenticable, through: :sender

  delegate :name, to: :authenticable

  validates :sender, :auction_conversation, presence: true

  after_create :notify_pusher

  private

  def notify_pusher
    Pusher.trigger('chat', 'new-chat', notify_pusher_body)
  end

  def notify_pusher_body
    {
        id:             self.id,
        body:           self.body,
        sender_name:    self.sender.authenticable.user.name_and_profile,
        created_at:     self.created_at.strftime("%I:%M %p"),
    }
  end
end

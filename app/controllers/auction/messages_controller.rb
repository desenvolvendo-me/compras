class Auction::MessagesController <  Auction::BaseController
  defaults resource_class: AuctionMessage

  layout false

  def create
    @conversation = AuctionConversation.find(params[:conversation_id])
    @message = @conversation.messages.build()
    @message.body = params[:auction_message][:body]
    @message.sender = current_user
    @message.save!
  end
end

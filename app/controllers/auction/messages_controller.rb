class Auction::MessageController <  Auction::BaseController
  defaults resource_class: AuctionMessage

  def create
    @conversation = AuctionConversation.find(params[:conversation_id])
    @message = @conversation.messages.build(params)
    @message.sender = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
  end
end

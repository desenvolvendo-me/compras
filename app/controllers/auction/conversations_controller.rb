class Auction::ConversationsController <  Auction::BaseController
  defaults resource_class: AuctionConversation

  layout false

  def create
    if AuctionConversation.find_by_auction_id(params[:auction]).present?
      @conversation = AuctionConversation.find_by_auction_id(params[:auction])
    else
      @conversation = AuctionConversation.create!(params)
    end

    render json: { conversation_id: @conversation.id }
  end

  def show
    @conversation = AuctionConversation.find(params[:id])
    @messages = @conversation.messages
    @message = AuctionMessage.new
  end
end

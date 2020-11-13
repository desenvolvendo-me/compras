class Auction::DisputeItemsController < Auction::BaseController
  defaults resource_class: AuctionDisputeItem

  before_filter :set_auction, except: :closed_items
  before_filter :set_auction_eager_load, only: :closed_items
  before_filter :check_proposal, if: proc{ current_user.creditor? }

  def new
    @conversation = @auction.conversation
    @messages = @conversation.messages
    @message = AuctionMessage.new

    super
  end

  def closed_items
    @creditor_proposal = @auction.creditor_proposal(current_user.authenticable.id)
  end

  private

  def set_auction_eager_load
    @auction = Auction.includes(:auction_creditor_proposal_items).find(params[:auction_id])
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end

  def check_proposal
    unless @auction.creditor_proposal(current_user.authenticable_id)
      redirect_to auction_auctions_path, :alert => I18n.t('auction.messages.must_have_registered_proposal')
    end
  end
end

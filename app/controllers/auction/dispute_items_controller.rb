class Auction::DisputeItemsController < Auction::BaseController
  defaults resource_class: AuctionDisputeItem

  before_filter :set_auction, except: :closed_items
  before_filter :set_auction_eager_load, only: :closed_items

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
end

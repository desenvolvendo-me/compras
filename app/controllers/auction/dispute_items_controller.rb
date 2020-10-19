class Auction::DisputeItemsController < Auction::BaseController
  defaults resource_class: AuctionDisputItem

  before_filter :set_auction

  private

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end

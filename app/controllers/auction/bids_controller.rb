class Auction::BidsController < Auction::BaseController
  default resource_class: AuctionBid

  before_filter :set_auction

  def new

  end

  private

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end

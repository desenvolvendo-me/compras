class Auction::BidsController < Auction::BaseController
  defaults resource_class: AuctionBid

  before_filter :set_auction

  def new
    if @auction.bids.empty?
      @auction.items.by_lot.each do |item|
        AuctionBid.create(lot: item.lot, auction_id: @auction.id)
      end
    end
    super
  end

  private

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end

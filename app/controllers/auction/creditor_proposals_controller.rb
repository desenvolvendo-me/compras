class Auction::CreditorProposalsController <  Auction::BaseController
  def new
    @auction = Auction.find(params[:auction_id])
    render :new
  end
end

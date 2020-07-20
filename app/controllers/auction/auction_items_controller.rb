class Auction::AuctionItemsController <  Auction::BaseController

  def group_lot
    items = AuctionItem.by_group_lot

    render :json => items.to_json
  end
end

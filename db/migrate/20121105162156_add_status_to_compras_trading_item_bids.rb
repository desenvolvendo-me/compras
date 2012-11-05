class AddStatusToComprasTradingItemBids < ActiveRecord::Migration
  def change
    add_column :compras_trading_item_bids, :status, :string

    TradingItemBid.find_each do |item|
      item.update_status(TradingItemBidStatus::WITH_PROPOSAL)
    end
  end
end

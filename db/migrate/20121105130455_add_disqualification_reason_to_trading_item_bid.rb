class AddDisqualificationReasonToTradingItemBid < ActiveRecord::Migration
  def change
    add_column :compras_trading_item_bids, :disqualification_reason, :text
  end
end

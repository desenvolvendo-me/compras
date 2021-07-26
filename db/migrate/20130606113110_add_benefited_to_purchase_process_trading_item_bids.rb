class AddBenefitedToPurchaseProcessTradingItemBids < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_trading_item_bids, :benefited, :boolean, default: false
  end
end

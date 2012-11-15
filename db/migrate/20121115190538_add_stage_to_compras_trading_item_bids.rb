class AddStageToComprasTradingItemBids < ActiveRecord::Migration
  def change
    add_column :compras_trading_item_bids, :stage, :string
  end
end

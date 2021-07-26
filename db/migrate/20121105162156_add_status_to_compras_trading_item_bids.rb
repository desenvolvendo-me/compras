class AddStatusToComprasTradingItemBids < ActiveRecord::Migration
  def change
    add_column :compras_trading_item_bids, :status, :string

    execute "UPDATE compras_trading_item_bids SET status = 'with_proposal'"
  end
end

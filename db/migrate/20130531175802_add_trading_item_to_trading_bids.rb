class AddTradingItemToTradingBids < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_trading_bids, :item_id, :integer

    remove_column :compras_purchase_process_trading_bids, :lot
    remove_column :compras_purchase_process_trading_bids, :purchase_process_trading_id
    remove_column :compras_purchase_process_trading_bids, :purchase_process_item_id

    add_index :compras_purchase_process_trading_bids, :item_id
    add_foreign_key :compras_purchase_process_trading_bids, :compras_purchase_process_trading_items,
      column: :item_id, name: :cpptb_trading_item_id_fk

    rename_table :compras_purchase_process_trading_bids, :compras_purchase_process_trading_item_bids
  end
end

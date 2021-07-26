class CreatePurchaseProcessTradingItems < ActiveRecord::Migration
  def up
    create_table :compras_purchase_process_trading_items do |t|
      t.integer :trading_id
      t.integer :item_id
      t.integer :lot
      t.decimal :reduction_rate_value, :precision => 10, :scale => 2
      t.decimal :reduction_rate_percent, :precision => 10, :scale => 2
    end

    add_index :compras_purchase_process_trading_items, :trading_id
    add_index :compras_purchase_process_trading_items, :item_id

    add_foreign_key :compras_purchase_process_trading_items, :compras_purchase_process_tradings, column: :trading_id, name: :cppti_trading_id
    add_foreign_key :compras_purchase_process_trading_items, :compras_purchase_process_items, column: :item_id, name: :cppti_item_id
  end
end

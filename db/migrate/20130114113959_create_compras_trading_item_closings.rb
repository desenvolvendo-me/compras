class CreateComprasTradingItemClosings < ActiveRecord::Migration
  def change
    create_table :compras_trading_item_closings do |t|
      t.references :trading_item
      t.string :status
      t.string :reason
      t.timestamps
    end

    add_index :compras_trading_item_closings, :trading_item_id
    add_foreign_key :compras_trading_item_closings, :compras_trading_items, :column => :trading_item_id
  end
end

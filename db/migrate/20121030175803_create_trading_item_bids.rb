class CreateTradingItemBids < ActiveRecord::Migration
  def change
    create_table :compras_trading_item_bids do |t|
      t.references :trading_item
      t.integer :round
      t.references :bidder
      t.decimal :amount, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :compras_trading_item_bids, :trading_item_id
    add_index :compras_trading_item_bids, :bidder_id

    add_foreign_key :compras_trading_item_bids, :compras_trading_items,
                    :column => :trading_item_id
    add_foreign_key :compras_trading_item_bids, :compras_bidders,
                    :column => :bidder_id
  end
end

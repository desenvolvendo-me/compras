class CreateAuctionDisputeItems < ActiveRecord::Migration
  def change
    create_table :compras_auction_dispute_items do |t|
      t.integer :auction_id
      t.integer :auction_item_id
      t.string  :status
    end

    add_index :compras_auction_dispute_items, :auction_id, name: :index_c_auct_dispute_items_on_auction_id
    add_index :compras_auction_dispute_items, :auction_id, name: :index_c_auct_dispute_items_on_auction_item_id


    add_foreign_key :compras_auction_dispute_items, :compras_auctions, column: :auction_id,
                    name: :c_auct_dispute_items_auction_fk

    add_foreign_key :compras_auction_dispute_items, :compras_auction_items, column: :auction_item_id,
                    name: :c_auct_dispute_items_auction_item_fk
  end
end

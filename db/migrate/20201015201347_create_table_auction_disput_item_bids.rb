class CreateTableAuctionDisputItemBids < ActiveRecord::Migration
  def change
    create_table :compras_auction_disput_item_bids do |t|
      t.integer :auction_disput_item_id
      t.integer :creditor_id
      t.decimal :amount, precision: 16, scale: 2
      t.timestamps
    end

    add_index :compras_auction_disput_item_bids, :auction_disput_item_id, name: :index_c_auct_dis_item_bids_on_auction_disput_item_id
    add_index :compras_auction_disput_item_bids, :creditor_id, name: :index_c_auct_dis_item_bids_on_creditor_id

    add_foreign_key :compras_auction_disput_item_bids, :compras_auction_disput_items, column: :auction_disput_item_id,
                    name: :auction_disput_item_on_auction_bids_fk

    add_foreign_key :compras_auction_disput_item_bids, :unico_creditors, column: :creditor_id,
                    name: :auction_disput_item_on_unico_creditors_fk
  end
end

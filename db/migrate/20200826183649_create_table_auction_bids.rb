class CreateTableAuctionBids < ActiveRecord::Migration
  def change
    create_table :compras_auction_bids do |t|
      t.integer :auction_id
      t.integer :creditor_id
      t.integer :lot
    end

    add_index :compras_auction_bids, :auction_id
    add_foreign_key :compras_auction_bids, :compras_auctions, column: :auction_id

    add_index :compras_auction_bids, :creditor_id
    add_foreign_key :compras_auction_bids, :unico_creditors, column: :creditor_id
  end
end

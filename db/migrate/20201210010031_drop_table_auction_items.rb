class DropTableAuctionItems < ActiveRecord::Migration
  def change
    drop_table :compras_auction_items
  end
end

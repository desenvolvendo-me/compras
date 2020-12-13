class DropAuctionDisputeItemBids < ActiveRecord::Migration
  def up
    drop_table :compras_auction_dispute_item_bids
    drop_table :compras_auction_dispute_items
  end
end

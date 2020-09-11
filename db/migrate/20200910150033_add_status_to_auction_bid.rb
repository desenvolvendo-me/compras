class AddStatusToAuctionBid < ActiveRecord::Migration
  def change
    add_column :compras_auction_bids, :status, :string
  end
end

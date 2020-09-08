class AddBidOppeningHourToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :bid_opening_time, :time
  end
end

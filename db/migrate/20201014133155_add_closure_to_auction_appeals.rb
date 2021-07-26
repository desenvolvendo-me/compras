class AddClosureToAuctionAppeals < ActiveRecord::Migration
  def change
    add_column :compras_auction_appeals, :closure_date, :date
    add_column :compras_auction_appeals, :closure_time, :time
  end
end

class AddOpenToAuctionAppeals < ActiveRecord::Migration
  def change
    add_column :compras_auction_appeals, :opening_date, :date
    add_column :compras_auction_appeals, :opening_time, :time
  end
end

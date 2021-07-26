class AddAppealFieldToAuctionAppeal < ActiveRecord::Migration
  def change
    add_column :compras_auction_appeals, :appeal_file, :string
  end
end

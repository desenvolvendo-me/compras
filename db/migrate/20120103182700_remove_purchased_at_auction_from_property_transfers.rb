class RemovePurchasedAtAuctionFromPropertyTransfers < ActiveRecord::Migration
  def change
    remove_column :property_transfers, :purchased_at_auction
  end
end

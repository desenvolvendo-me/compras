class AddAuctionFlagToProfiles < ActiveRecord::Migration
  def change
    add_column :compras_profiles, :auction_profile, :boolean
  end
end

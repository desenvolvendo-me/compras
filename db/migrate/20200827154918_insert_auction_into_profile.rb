class InsertAuctionIntoProfile < ActiveRecord::Migration
  def change
    profile = Profile.where(id: 10)

    if profile.present?
      profile.last.auction_profile = true
      profile.last.save!
    end
  end
end

class RenameBidOpeningBidOpeningStatusToStatus < ActiveRecord::Migration
  def change
    rename_column :bid_openings, :bid_opening_status, :status
  end
end

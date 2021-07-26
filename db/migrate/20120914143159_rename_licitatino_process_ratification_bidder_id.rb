class RenameLicitatinoProcessRatificationBidderId < ActiveRecord::Migration
  def up
    rename_column :compras_licitation_process_ratifications,
                  :licitation_process_bidder_id, :bidder_id
  end
end

class RenameLicitationProcessClassificationBidderId < ActiveRecord::Migration
  def change
    rename_column :compras_licitation_process_classifications,
                  :licitation_process_bidder_id, :bidder_id
  end
end

class RenameAccreditedRepresentativeBidderId < ActiveRecord::Migration
  def change
    rename_column :compras_accredited_representatives, :licitation_process_bidder_id,
                  :bidder_id
  end
end

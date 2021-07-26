class RenameLicitationProcessBidderProposalsToBidderProposals < ActiveRecord::Migration
  def change
    rename_table :compras_licitation_process_bidder_proposals,
                 :compras_bidder_proposals

    rename_column :compras_bidder_proposals, :licitation_process_bidder_id,
                  :bidder_id
  end
end

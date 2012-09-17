class RenameLicitationProcessRatificationItemBidderProposalId < ActiveRecord::Migration
  def change
    rename_column :compras_licitation_process_ratification_items,
                  :licitation_process_bidder_proposal_id, :bidder_proposal_id
  end
end

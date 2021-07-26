class ChangeComprasLicitationProcessBidderProposalsClassificationToInteger < ActiveRecord::Migration
  def change
    change_column :compras_licitation_process_bidder_proposals, :classification, :integer
  end
end

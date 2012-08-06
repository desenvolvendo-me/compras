class ChangeComprasLicitationProcessBidderProposalsSituationToString < ActiveRecord::Migration
  def change
    change_column :compras_licitation_process_bidder_proposals, :situation, :string
  end
end

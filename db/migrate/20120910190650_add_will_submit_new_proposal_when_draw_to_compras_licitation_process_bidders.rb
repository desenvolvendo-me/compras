class AddWillSubmitNewProposalWhenDrawToComprasLicitationProcessBidders < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_bidders, :will_submit_new_proposal_when_draw, :boolean, :default => true
  end
end

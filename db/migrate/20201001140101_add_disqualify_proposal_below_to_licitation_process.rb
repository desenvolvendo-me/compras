class AddDisqualifyProposalBelowToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :disqualify_proposal_below, :decimal, precision: 10, scale: 2
  end
end

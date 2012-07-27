class AddRatificatedToLicitationProcessBidderProposals < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_bidder_proposals, :ratificated, :boolean, :default => false
    add_column :compras_licitation_process_bidder_proposals, :licitation_process_ratification_id, :integer

    add_index :compras_licitation_process_bidder_proposals, :licitation_process_ratification_id, :name => :clpbp_ratification_id

    add_foreign_key :compras_licitation_process_bidder_proposals, :compras_licitation_process_ratifications,
                    :column => :licitation_process_ratification_id, :name => :clpbp_ratifications_fk
  end
end

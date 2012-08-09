class CreateLicitationProcessRatificationItems < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_process_bidder_proposals, :licitation_process_ratification_id
    remove_column :compras_licitation_process_bidder_proposals, :ratificated

    create_table :compras_licitation_process_ratification_items do |t|
      t.references :licitation_process_ratification
      t.references :licitation_process_bidder_proposal
      t.boolean :ratificated, :default => false

      t.timestamps
    end

    add_index :compras_licitation_process_ratification_items, :licitation_process_ratification_id, :name => :clpri_lpr_id
    add_index :compras_licitation_process_ratification_items, :licitation_process_bidder_proposal_id, :name => :clpri_lpbp_id

    add_foreign_key :compras_licitation_process_ratification_items, :compras_licitation_process_ratifications,
                    :column => :licitation_process_ratification_id, :name => :clpri_clpr_fk
    add_foreign_key :compras_licitation_process_ratification_items, :compras_licitation_process_bidder_proposals,
                    :column => :licitation_process_bidder_proposal_id, :name => :clpri_clpbp_fk
  end
end

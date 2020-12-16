class AddLicitationProcessToCreditorProposalTerms < ActiveRecord::Migration
  def change
    add_column :compras_creditor_proposal_terms, :licitation_process_id, :integer

    add_index :compras_creditor_proposal_terms, :licitation_process_id, name: :licitation_proposal_terms_index
    add_foreign_key :compras_creditor_proposal_terms, :compras_licitation_processes, column: :licitation_process_id,
                    name: :licitation_process_terms_fk
  end
end

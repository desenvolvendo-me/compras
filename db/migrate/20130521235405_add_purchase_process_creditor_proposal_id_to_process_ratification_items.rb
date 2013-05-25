class AddPurchaseProcessCreditorProposalIdToProcessRatificationItems < ActiveRecord::Migration
  def up
    remove_column :compras_licitation_process_ratification_items, :bidder_proposal_id

    add_column :compras_licitation_process_ratification_items, :purchase_process_creditor_proposal_id,
      :integer

    add_foreign_key :compras_licitation_process_ratification_items, :compras_purchase_process_creditor_proposals,
      name: :clprt_purchase_process_creditor_proposal_id_fk, column: :purchase_process_creditor_proposal_id

    add_index :compras_licitation_process_ratification_items, :purchase_process_creditor_proposal_id,
      name: :clprt_purchase_process_creditor_proposal_id
  end

  def down
    add_column :compras_licitation_process_ratification_items, :bidder_proposal_id, :integer

    remove_column :compras_licitation_process_ratification_items, :purchase_process_creditor_proposal_id
  end
end

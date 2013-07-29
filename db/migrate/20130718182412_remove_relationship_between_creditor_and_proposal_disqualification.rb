class RemoveRelationshipBetweenCreditorAndProposalDisqualification < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_creditor_disqualifications, :creditor_id
  end
end

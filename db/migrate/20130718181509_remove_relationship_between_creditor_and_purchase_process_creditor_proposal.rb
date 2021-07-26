class RemoveRelationshipBetweenCreditorAndPurchaseProcessCreditorProposal < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_creditor_proposals, :creditor_id
  end
end

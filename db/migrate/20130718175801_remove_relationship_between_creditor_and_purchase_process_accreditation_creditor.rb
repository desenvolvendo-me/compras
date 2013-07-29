class RemoveRelationshipBetweenCreditorAndPurchaseProcessAccreditationCreditor < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_accreditation_creditors, :creditor_id
  end
end

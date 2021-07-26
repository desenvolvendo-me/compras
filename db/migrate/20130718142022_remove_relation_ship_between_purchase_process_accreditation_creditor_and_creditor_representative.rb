class RemoveRelationShipBetweenPurchaseProcessAccreditationCreditorAndCreditorRepresentative < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_accreditation_creditors, :creditor_representative_id
  end
end

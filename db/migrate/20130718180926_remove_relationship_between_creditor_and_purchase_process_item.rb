class RemoveRelationshipBetweenCreditorAndPurchaseProcessItem < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_items, :creditor_id
  end
end

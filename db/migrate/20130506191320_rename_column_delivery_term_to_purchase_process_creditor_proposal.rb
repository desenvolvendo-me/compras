class RenameColumnDeliveryTermToPurchaseProcessCreditorProposal < ActiveRecord::Migration
  def change
    rename_column :compras_purchase_process_creditor_proposals, :delivery_term, :delivery_date
  end
end

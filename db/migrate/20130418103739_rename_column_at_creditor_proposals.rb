class RenameColumnAtCreditorProposals < ActiveRecord::Migration
  def up
    rename_column :compras_purchase_process_creditor_proposals, :administrative_process_budget_allocation_item_id, :purchase_process_item_id
  end

  def down
    rename_column :compras_purchase_process_creditor_proposals, :purchase_process_item_id, :administrative_process_budget_allocation_item_id
  end
end

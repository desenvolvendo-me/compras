class RenameTableAdministrativeProcessBudgetAllocationItem < ActiveRecord::Migration
  def up
    rename_table :compras_administrative_process_budget_allocation_items, :compras_purchase_process_items

    rename_column :compras_bidder_proposals,                    :administrative_process_budget_allocation_item_id, :purchase_process_item_id
    rename_column :compras_price_registration_items,            :administrative_process_budget_allocation_item_id, :purchase_process_item_id
    rename_column :compras_trading_items,                       :administrative_process_budget_allocation_item_id, :purchase_process_item_id
  end

  def down
    rename_table  :compras_purchase_process_items, :compras_administrative_process_budget_allocation_items

    rename_column :compras_bidder_proposals,                    :purchase_process_item_id, :administrative_process_budget_allocation_item_id
    rename_column :compras_price_registration_items,            :purchase_process_item_id, :administrative_process_budget_allocation_item_id
    rename_column :compras_trading_items,                       :purchase_process_item_id, :administrative_process_budget_allocation_item_id
  end
end

class AddCreditorIdToAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocation_items, :creditor_id, :integer

    add_foreign_key :compras_administrative_process_budget_allocation_items, :compras_creditors,
      :column => :creditor_id, :name => :adm_proc_budg_alloc_items_creditor_id_fk

    add_index :compras_administrative_process_budget_allocation_items, :creditor_id,
      :name => :index_adm_proc_budg_alloc_items_on_creditor_id
  end
end

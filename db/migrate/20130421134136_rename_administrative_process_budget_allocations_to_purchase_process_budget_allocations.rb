class RenameAdministrativeProcessBudgetAllocationsToPurchaseProcessBudgetAllocations < ActiveRecord::Migration
  def up
    rename_table :compras_administrative_process_budget_allocations, :compras_purchase_process_budget_allocations

    execute <<-SQL
      ALTER INDEX compras_administrative_process_budget_allocations_pkey RENAME TO compras_purchase_process_budget_allocations_pkey;
      ALTER INDEX capba_budget_allocation_id RENAME TO cppba_budget_allocation_id;
      ALTER INDEX capba_licitation_process_idx RENAME TO cppba_licitation_process_idx;
      ALTER INDEX index_adm_proc_budget_alloc_expense_nature_id RENAME TO cppba_expense_nature_id;
      DROP INDEX index_adm_proc_bdgt_alloc_on_budget_allocation_id;
    SQL
  end

  def down
    rename_table :compras_purchase_process_budget_allocations, :compras_administrative_process_budget_allocations

    execute <<-SQL
      ALTER INDEX compras_purchase_process_budget_allocations_pkey RENAME TO compras_administrative_process_budget_allocations_pkey;
      ALTER INDEX cppba_budget_allocation_id RENAME TO capba_budget_allocation_id;
      ALTER INDEX cppba_licitation_process_idx  RENAME TO capba_licitation_process_idx;
      ALTER INDEX cppba_expense_nature_id RENAME TO index_adm_proc_budget_alloc_expense_nature_id;
    SQL

    add_index :compras_administrative_process_budget_allocations, :budget_allocation_id, name: :index_adm_proc_bdgt_alloc_on_budget_allocation_id
  end
end

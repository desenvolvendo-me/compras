class RenameColumnExpenseNatureSplitFromAdministrativeProcessBudgetAllocations < ActiveRecord::Migration
  def change
    remove_foreign_key :compras_administrative_process_budget_allocations, name: :adm_proc_budget_alloc_expense_nature_split_fk
    remove_index       :compras_administrative_process_budget_allocations, name: :index_adm_proc_budget_alloc_expense_nature_split_id

    rename_column :compras_administrative_process_budget_allocations, :expense_nature_split_id, :expense_nature_id

    add_foreign_key :compras_administrative_process_budget_allocations, :compras_expense_natures,
                    :column => :expense_nature_id, :name => :adm_proc_budget_alloc_expense_nature_fk

    add_index :compras_administrative_process_budget_allocations, :expense_nature_id,
              :name => :index_adm_proc_budget_alloc_expense_nature_id
  end
end

class AddExpenseNatureSplitToAdministrativeProcessBudgetAllocations < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocations, :expense_nature_split_id, :integer

    add_foreign_key :compras_administrative_process_budget_allocations, :compras_expense_natures,
                    :column => :expense_nature_split_id, :name => :adm_proc_budget_alloc_expense_nature_split_fk

    add_index :compras_administrative_process_budget_allocations, :expense_nature_split_id,
              :name => :index_adm_proc_budget_alloc_expense_nature_split_id
  end
end

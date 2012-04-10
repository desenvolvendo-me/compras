class RenameBudgetAllocationsExpenseElementIdToExpenseNatureId < ActiveRecord::Migration
  def change
    rename_column :budget_allocations, :expense_element_id, :expense_nature_id
  end
end

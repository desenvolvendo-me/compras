class RenamePurchaseSolicitationBudgetAllocationsExpenseElementIdToExpenseNatureId < ActiveRecord::Migration
  def up
    rename_column :purchase_solicitation_budget_allocations, :expense_element_id, :expense_nature_id
  end
end

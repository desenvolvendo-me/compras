class RemoveExpenseNatureFromPurchaseSolicitationBudgetAllocations < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_solicitation_budget_allocations, :expense_nature_id
  end
end

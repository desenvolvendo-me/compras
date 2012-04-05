class RemoveEstimatedValueFromTablePurchaseSolicitationBudgetAllocations < ActiveRecord::Migration
  def change
    remove_column :purchase_solicitation_budget_allocations, :estimated_value
  end
end

class RemoveGoalAndDescriptionFromComprasBudgetAllocation < ActiveRecord::Migration
  def change
    remove_column :compras_budget_allocations, :goal
    remove_column :compras_budget_allocations, :description
  end
end

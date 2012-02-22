class RemoveFunctionFromBudgetAllocation < ActiveRecord::Migration
  def change
    remove_column :budget_allocations, :function_id
  end
end

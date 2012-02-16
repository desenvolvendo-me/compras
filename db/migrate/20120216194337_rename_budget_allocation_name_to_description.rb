class RenameBudgetAllocationNameToDescription < ActiveRecord::Migration
  def change
    rename_column :budget_allocations, :name, :description
  end
end

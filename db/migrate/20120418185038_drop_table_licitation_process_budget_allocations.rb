class DropTableLicitationProcessBudgetAllocations < ActiveRecord::Migration
  def change
    drop_table :licitation_process_budget_allocations
  end
end

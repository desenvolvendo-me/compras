class DropTableLicitationProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    drop_table :licitation_process_budget_allocation_items
  end
end

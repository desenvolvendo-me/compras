class AddBudgetAllocationsYearAndEntityIdIndex < ActiveRecord::Migration
  def change
    add_index :compras_budget_allocations, [:code, :entity_id, :year], :unique => true
  end
end

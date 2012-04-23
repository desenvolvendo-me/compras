class AddKindToBudgetAllocations < ActiveRecord::Migration
  def change
    add_column :budget_allocations, :kind, :string
  end
end

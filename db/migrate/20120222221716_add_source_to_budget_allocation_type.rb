class AddSourceToBudgetAllocationType < ActiveRecord::Migration
  def change
    add_column :budget_allocation_types, :source, :string
  end
end

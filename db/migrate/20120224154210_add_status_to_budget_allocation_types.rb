class AddStatusToBudgetAllocationTypes < ActiveRecord::Migration
  def change
    add_column :budget_allocation_types, :status, :string
  end
end

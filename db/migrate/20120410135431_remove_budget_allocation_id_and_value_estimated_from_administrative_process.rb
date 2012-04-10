class RemoveBudgetAllocationIdAndValueEstimatedFromAdministrativeProcess < ActiveRecord::Migration
  def up
    remove_column :administrative_processes, :budget_allocation_id
    remove_column :administrative_processes, :value_estimated
  end

  def down
    add_column :administrative_processes, :value_estimated, :string
    add_column :administrative_processes, :budget_allocation_id, :string
  end
end

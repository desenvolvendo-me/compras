class RemoveBudgetAllocationIdAndValueEstimatedFromAdministrativeProcess < ActiveRecord::Migration
  def change
    remove_column :administrative_processes, :budget_allocation_id
    remove_column :administrative_processes, :value_estimated
  end
end

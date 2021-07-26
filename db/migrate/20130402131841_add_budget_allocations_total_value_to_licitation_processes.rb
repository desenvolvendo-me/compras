class AddBudgetAllocationsTotalValueToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :budget_allocations_total_value, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end

class AddBudgetAllocationYearOnLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :budget_allocation_year, :integer
  end
end

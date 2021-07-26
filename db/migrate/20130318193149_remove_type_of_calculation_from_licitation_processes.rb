class RemoveTypeOfCalculationFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :type_of_calculation
  end
end

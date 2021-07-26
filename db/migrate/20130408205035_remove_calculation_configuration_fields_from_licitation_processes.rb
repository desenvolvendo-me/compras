class RemoveCalculationConfigurationFieldsFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :disqualify_by_documentation_problem
    remove_column :compras_licitation_processes, :disqualify_by_maximum_value
    remove_column :compras_licitation_processes, :consider_law_of_proposals
  end
end

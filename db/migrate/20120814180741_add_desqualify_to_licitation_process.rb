class AddDesqualifyToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :disqualify_by_documentation_problem, :boolean, :default => false
    add_column :compras_licitation_processes, :disqualify_by_maximum_value, :boolean, :default => false
    add_column :compras_licitation_processes, :consider_law_of_proposals, :boolean, :default => false
  end
end

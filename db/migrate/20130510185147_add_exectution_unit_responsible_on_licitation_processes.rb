class AddExectutionUnitResponsibleOnLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :execution_unit_responsible, :string
  end
end

class RemoveExecutionTypeFromContractsAndAddItToLicitationProcesses < ActiveRecord::Migration
  def up
    remove_column :compras_contracts, :execution_type
    add_column :compras_licitation_processes, :execution_type, :string, :require => true
  end

  def down
    remove_column :compras_licitation_processes, :execution_type
    add_column :compras_contracts, :execution_type, :string, :require => true
  end
end

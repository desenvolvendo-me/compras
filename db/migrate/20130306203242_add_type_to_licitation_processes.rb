class AddTypeToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :type_of_purchase, :string
  end
end

class AddTypeOfRemovalToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :type_of_removal, :string
  end
end

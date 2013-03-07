class AddExtensionClauseToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :extension_clause, :string
  end
end

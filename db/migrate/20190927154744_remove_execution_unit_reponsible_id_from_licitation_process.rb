class RemoveExecutionUnitReponsibleIdFromLicitationProcess < ActiveRecord::Migration
  def up
    remove_column :compras_licitation_processes, :execution_unit_responsible_id
  end

  def down
    add_column    :compras_licitation_processes, :execution_unit_responsible_id, :integer
  end
end

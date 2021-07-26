class RemoveTableComprasLicitationObjects < ActiveRecord::Migration
  def change
    drop_table :compras_licitation_objects_compras_materials
    drop_table :compras_licitation_objects
  end
end

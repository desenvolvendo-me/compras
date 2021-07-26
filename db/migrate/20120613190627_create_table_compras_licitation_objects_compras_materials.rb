class CreateTableComprasLicitationObjectsComprasMaterials < ActiveRecord::Migration
  def change
    create_table "compras_licitation_objects_compras_materials", :id => false do |t|
      t.integer "material_id"
      t.integer "licitation_object_id"
    end

    add_index "compras_licitation_objects_compras_materials", ["licitation_object_id"], :name => "clocm_licitation_object_id"
    add_index "compras_licitation_objects_compras_materials", ["material_id"], :name => "clocm_material_id"
  end
end

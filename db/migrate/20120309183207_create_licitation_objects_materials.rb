class CreateLicitationObjectsMaterials < ActiveRecord::Migration
  def up
    create_table :licitation_objects_materials, :id => false do |t|
      t.integer :material_id
      t.integer :licitation_object_id
    end

    add_index :licitation_objects_materials, :material_id
    add_index :licitation_objects_materials, :licitation_object_id

    add_foreign_key :licitation_objects_materials, :materials
    add_foreign_key :licitation_objects_materials, :licitation_objects
  end
end

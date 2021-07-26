class AddMaterialsControls < ActiveRecord::Migration
  def change
    create_table :compras_materials_controls do |t|
      t.integer :material_id
      t.integer :warehouse_id
      t.decimal :minimum_quantity,     :precision => 10, :scale => 3
      t.decimal :maximum_quantity,     :precision => 10, :scale => 3
      t.decimal :average_quantity,     :precision => 10, :scale => 3
      t.decimal :replacement_quantity, :precision => 10, :scale => 3
      t.timestamps
    end

    add_index :compras_materials_controls, :material_id
    add_index :compras_materials_controls, :warehouse_id

    add_foreign_key :compras_materials_controls, :compras_materials, :column => :material_id
    add_foreign_key :compras_materials_controls, :compras_warehouses, :column => :warehouse_id
  end
end

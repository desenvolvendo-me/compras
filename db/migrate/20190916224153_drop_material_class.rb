class DropMaterialClass < ActiveRecord::Migration
  def up
    drop_table :compras_material_classes
  end

  def down

    create_table "compras_material_classes" do |t|
      t.integer  "description"
      t.text     "details"
      t.string   "class_number"
      t.string   "mask"
      t.string   "masked_number"
      t.boolean  "imported"
      t.boolean  "has_children"
    end

  end
end

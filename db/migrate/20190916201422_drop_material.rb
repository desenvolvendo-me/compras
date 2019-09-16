class DropMaterial < ActiveRecord::Migration
  def up
    drop_table :compras_materials
  end

  def down

    create_table "compras_materials" do |t|
      t.integer  "material_class_id"
      t.string   "code"
      t.string   "description"
      t.text     "detailed_description"
      t.integer  "reference_unit_id"
      t.string   "manufacturer"
      t.boolean  "combustible"
      t.string   "material_type"
      t.integer  "expense_nature_id"
      t.boolean  "active"
      t.boolean  "control_amount"
    end

    add_index "compras_materials", ["expense_nature_id"], :name => "cm_expense_nature_id"
    add_index "compras_materials", ["material_class_id"], :name => "cm_materials_class_id"
    add_index "compras_materials", ["reference_unit_id"], :name => "cm_reference_unit_id"

  end
end

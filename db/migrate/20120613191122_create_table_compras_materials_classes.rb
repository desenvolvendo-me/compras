class CreateTableComprasMaterialsClasses < ActiveRecord::Migration
  def change
    create_table "compras_materials_classes" do |t|
      t.integer  "materials_group_id"
      t.string   "description"
      t.text     "details"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
      t.string   "class_number"
    end

    add_index "compras_materials_classes", ["materials_group_id"], :name => "cmc_materials_group_id"
  end
end

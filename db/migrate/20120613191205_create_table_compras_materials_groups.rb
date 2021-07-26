class CreateTableComprasMaterialsGroups < ActiveRecord::Migration
  def change
    create_table "compras_materials_groups" do |t|
      t.string   "group_number"
      t.string   "description"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end
  end
end

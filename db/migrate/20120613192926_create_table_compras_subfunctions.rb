class CreateTableComprasSubfunctions < ActiveRecord::Migration
  def change
    create_table "compras_subfunctions" do |t|
      t.string   "code"
      t.string   "description"
      t.integer  "function_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.integer  "entity_id"
      t.integer  "year"
    end

    add_index "compras_subfunctions", ["entity_id"], :name => "cs_entity_id"
    add_index "compras_subfunctions", ["function_id"], :name => "cs_function_id"
  end
end

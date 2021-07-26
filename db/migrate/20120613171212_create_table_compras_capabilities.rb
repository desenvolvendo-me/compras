class CreateTableComprasCapabilities < ActiveRecord::Migration
  def change
    create_table "compras_capabilities" do |t|
      t.integer  "entity_id"
      t.integer  "year"
      t.string   "description"
      t.text     "goal"
      t.string   "kind"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.string   "status"
      t.string   "source"
    end

    add_index "compras_capabilities", ["entity_id"], :name => "cc_entity_id"
  end
end

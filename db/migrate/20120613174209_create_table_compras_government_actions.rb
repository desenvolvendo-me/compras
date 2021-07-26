class CreateTableComprasGovernmentActions < ActiveRecord::Migration
  def change
    create_table "compras_government_actions" do |t|
      t.integer  "year"
      t.string   "description"
      t.string   "status"
      t.integer  "entity_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "compras_government_actions", ["entity_id"], :name => "cga_entity_id"
  end
end

class CreateTableComprasGovernmentPrograms < ActiveRecord::Migration
  def change
    create_table "compras_government_programs" do |t|
      t.integer  "entity_id"
      t.integer  "year"
      t.string   "description"
      t.string   "status"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "compras_government_programs", ["entity_id"], :name => "cgp_entity_id"
  end
end

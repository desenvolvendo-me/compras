class CreateTableComprasManagementUnits < ActiveRecord::Migration
  def change
    create_table "compras_management_units" do |t|
      t.string   "description"
      t.string   "acronym"
      t.string   "status"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.integer  "year"
      t.integer  "entity_id"
    end

    add_index "compras_management_units", ["entity_id"], :name => "cmu_entity_id"
  end
end

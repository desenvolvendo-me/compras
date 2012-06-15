class CreateTableComprasEmployees < ActiveRecord::Migration
  def change
    create_table "compras_employees" do |t|
      t.integer  "person_id"
      t.string   "registration"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
      t.integer  "position_id"
    end

    add_index "compras_employees", ["person_id"], :name => "ce_person_id"
    add_index "compras_employees", ["position_id"], :name => "ce_position_id"
  end
end

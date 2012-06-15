class CreateTableComprasSignatures < ActiveRecord::Migration
  def change
    create_table "compras_signatures" do |t|
      t.integer  "person_id"
      t.integer  "position_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "compras_signatures", ["person_id"], :name => "cs_person_id"
    add_index "compras_signatures", ["position_id"], :name => "cs_position_id"
  end
end

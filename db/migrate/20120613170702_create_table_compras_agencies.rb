class CreateTableComprasAgencies < ActiveRecord::Migration
  def change
    create_table "compras_agencies" do |t|
      t.string   "name"
      t.string   "number"
      t.string   "digit"
      t.integer  "city_id"
      t.integer  "bank_id"
      t.string   "phone"
      t.string   "fax"
      t.string   "email"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "compras_agencies", ["bank_id"], :name => "ca_bank_id"
    add_index "compras_agencies", ["city_id"], :name => "ca_city_id"
  end
end

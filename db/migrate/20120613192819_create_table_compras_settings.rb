class CreateTableComprasSettings < ActiveRecord::Migration
  def change
    create_table "compras_settings" do |t|
      t.string   "key"
      t.string   "value"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "compras_settings", ["key"], :name => "cs_key"
  end
end

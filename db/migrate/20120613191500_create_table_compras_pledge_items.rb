class CreateTableComprasPledgeItems < ActiveRecord::Migration
  def change
    create_table "compras_pledge_items" do |t|
      t.integer  "pledge_id"
      t.integer  "material_id"
      t.string   "description"
      t.integer  "quantity"
      t.decimal  "unit_price",  :precision => 10, :scale => 2
      t.datetime "created_at",                                 :null => false
      t.datetime "updated_at",                                 :null => false
    end

    add_index "compras_pledge_items", ["material_id"], :name => "cpi_material_id"
    add_index "compras_pledge_items", ["pledge_id"], :name => "cpi_pledge_id"
  end
end

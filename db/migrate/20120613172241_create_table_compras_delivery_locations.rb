class CreateTableComprasDeliveryLocations < ActiveRecord::Migration
  def change
    create_table "compras_delivery_locations" do |t|
      t.string   "description"
      t.integer  "address_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "compras_delivery_locations", ["address_id"], :name => "cdl_address_id"
  end
end

class CreateTableComprasPriceCollectionLotItems < ActiveRecord::Migration
  def change
    create_table "compras_price_collection_lot_items" do |t|
      t.integer  "price_collection_lot_id"
      t.integer  "material_id"
      t.integer  "quantity"
      t.string   "brand"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "compras_price_collection_lot_items", ["material_id"], :name => "cpcli_material_id"
    add_index "compras_price_collection_lot_items", ["price_collection_lot_id"], :name => "cpcli_price_collection_lot_id"
  end
end

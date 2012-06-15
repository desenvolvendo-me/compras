class CreateTableComprasPriceCollectionLots < ActiveRecord::Migration
  def change
    create_table "compras_price_collection_lots" do |t|
      t.integer  "price_collection_id"
      t.text     "observations"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
    end

    add_index "compras_price_collection_lots", ["price_collection_id"], :name => "cpcl_price_collection_id"
  end
end

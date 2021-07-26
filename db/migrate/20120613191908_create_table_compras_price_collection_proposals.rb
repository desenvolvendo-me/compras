class CreateTableComprasPriceCollectionProposals < ActiveRecord::Migration
  def change
    create_table "compras_price_collection_proposals" do |t|
      t.integer  "price_collection_id"
      t.integer  "provider_id"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
      t.string   "status"
    end

    add_index "compras_price_collection_proposals", ["price_collection_id"], :name => "cpcp_price_collection_id"
    add_index "compras_price_collection_proposals", ["provider_id"], :name => "cpcp_provider_id"
  end
end

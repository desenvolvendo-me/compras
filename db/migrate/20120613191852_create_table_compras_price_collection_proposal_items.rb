class CreateTableComprasPriceCollectionProposalItems < ActiveRecord::Migration
  def change
    create_table "compras_price_collection_proposal_items" do |t|
      t.integer  "price_collection_proposal_id"
      t.integer  "price_collection_lot_item_id"
      t.decimal  "unit_price",                   :precision => 10, :scale => 2
      t.datetime "created_at",                                                  :null => false
      t.datetime "updated_at",                                                  :null => false
    end

    add_index "compras_price_collection_proposal_items", ["price_collection_lot_item_id"], :name => "cpcpi_price_collection_lot_item_id"
    add_index "compras_price_collection_proposal_items", ["price_collection_proposal_id"], :name => "cpcpi_price_collection_proposal_id"
  end
end

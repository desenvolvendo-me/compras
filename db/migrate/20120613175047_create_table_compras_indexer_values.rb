class CreateTableComprasIndexerValues < ActiveRecord::Migration
  def change
    create_table "compras_indexer_values" do |t|
      t.date     "date"
      t.decimal  "value",      :precision => 14, :scale => 6
      t.integer  "indexer_id"
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
    end

    add_index "compras_indexer_values", ["indexer_id"], :name => "civ_indexer_id"
  end
end

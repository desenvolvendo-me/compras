class CreateTableComprasIndexers < ActiveRecord::Migration
  def change
    create_table "compras_indexers" do |t|
      t.string   "name"
      t.integer  "currency_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "compras_indexers", ["currency_id"], :name => "ci_currency_id"
  end
end

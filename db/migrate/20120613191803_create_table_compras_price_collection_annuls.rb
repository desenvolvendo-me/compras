class CreateTableComprasPriceCollectionAnnuls < ActiveRecord::Migration
  def change
    create_table "compras_price_collection_annuls" do |t|
      t.integer  "price_collection_id"
      t.integer  "employee_id"
      t.date     "date"
      t.text     "description"
      t.string   "annul_type"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
    end

    add_index "compras_price_collection_annuls", ["employee_id"], :name => "cpca_employee_id"
    add_index "compras_price_collection_annuls", ["price_collection_id"], :name => "cpca_price_collection_id"
  end
end

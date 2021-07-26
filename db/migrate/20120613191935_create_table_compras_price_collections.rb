class CreateTableComprasPriceCollections < ActiveRecord::Migration
  def change
    create_table "compras_price_collections" do |t|
      t.integer  "collection_number"
      t.integer  "year"
      t.date     "date"
      t.integer  "delivery_location_id"
      t.integer  "employee_id"
      t.integer  "payment_method_id"
      t.text     "object_description"
      t.text     "observations"
      t.date     "expiration"
      t.string   "status"
      t.datetime "created_at",             :null => false
      t.datetime "updated_at",             :null => false
      t.integer  "period"
      t.string   "period_unit"
      t.integer  "proposal_validity"
      t.string   "proposal_validity_unit"
      t.string   "type_of_calculation"
    end

    add_index "compras_price_collections", ["collection_number", "year"], :name => "cpc_year"
    add_index "compras_price_collections", ["delivery_location_id"], :name => "cpc_delivery_location_id"
    add_index "compras_price_collections", ["employee_id"], :name => "cpc_employee_id"
    add_index "compras_price_collections", ["payment_method_id"], :name => "cpc_payment_method_id"
  end
end

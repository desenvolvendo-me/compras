class CreateTableComprasPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table "compras_purchase_solicitations" do |t|
      t.integer  "accounting_year"
      t.date     "request_date"
      t.integer  "responsible_id"
      t.text     "justification"
      t.integer  "delivery_location_id"
      t.string   "kind"
      t.text     "general_observations"
      t.string   "service_status"
      t.date     "liberation_date"
      t.integer  "liberator_id"
      t.text     "service_observations"
      t.text     "no_service_justification"
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
      t.integer  "budget_structure_id"
      t.integer  "code"
    end

    add_index "compras_purchase_solicitations", ["accounting_year", "code"], :name => "cps_code"
    add_index "compras_purchase_solicitations", ["budget_structure_id"], :name => "cps_budget_structure_id"
    add_index "compras_purchase_solicitations", ["delivery_location_id"], :name => "cps_delivery_location_id"
    add_index "compras_purchase_solicitations", ["liberator_id"], :name => "cps_liberator_id"
    add_index "compras_purchase_solicitations", ["responsible_id"], :name => "cps_responsible_id"
  end
end

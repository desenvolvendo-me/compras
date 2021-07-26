class CreateTableComprasDirectPurchases < ActiveRecord::Migration
  def change
    create_table "compras_direct_purchases" do |t|
      t.integer  "year"
      t.date     "date"
      t.integer  "legal_reference_id"
      t.string   "modality"
      t.integer  "provider_id"
      t.integer  "budget_structure_id"
      t.integer  "licitation_object_id"
      t.integer  "delivery_location_id"
      t.integer  "employee_id"
      t.integer  "payment_method_id"
      t.string   "price_collection"
      t.string   "price_registration"
      t.text     "observation"
      t.datetime "created_at",           :null => false
      t.datetime "updated_at",           :null => false
      t.string   "status"
      t.string   "pledge_type"
      t.integer  "period"
      t.string   "period_unit"
      t.integer  "direct_purchase"
    end

    add_index "compras_direct_purchases", ["budget_structure_id"], :name => "cdp_budget_structure_id"
    add_index "compras_direct_purchases", ["delivery_location_id"], :name => "cdp_delivery_location_id"
    add_index "compras_direct_purchases", ["direct_purchase"], :name => "cdp_direct_purchase"
    add_index "compras_direct_purchases", ["employee_id"], :name => "cdp_employee_id"
    add_index "compras_direct_purchases", ["legal_reference_id"], :name => "cdp_legal_reference_id"
    add_index "compras_direct_purchases", ["licitation_object_id"], :name => "cdp_licitation_object_id"
    add_index "compras_direct_purchases", ["payment_method_id"], :name => "cdp_payment_method_id"
    add_index "compras_direct_purchases", ["provider_id"], :name => "cdp_provider_id"
  end
end

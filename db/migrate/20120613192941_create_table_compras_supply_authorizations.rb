class CreateTableComprasSupplyAuthorizations < ActiveRecord::Migration
  def change
    create_table "compras_supply_authorizations" do |t|
      t.integer  "year"
      t.string   "code"
      t.integer  "direct_purchase_id"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "compras_supply_authorizations", ["code", "year"], :name => "csa_year", :unique => true
    add_index "compras_supply_authorizations", ["direct_purchase_id"], :name => "csa_direct_purchase_id"
  end
end

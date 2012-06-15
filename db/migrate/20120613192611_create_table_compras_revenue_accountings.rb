class CreateTableComprasRevenueAccountings < ActiveRecord::Migration
  def change
    create_table "compras_revenue_accountings" do |t|
      t.integer  "entity_id"
      t.integer  "year"
      t.string   "code"
      t.integer  "revenue_nature_id"
      t.integer  "capability_id"
      t.datetime "created_at",                                       :null => false
      t.datetime "updated_at",                                       :null => false
      t.string   "kind"
      t.decimal  "value",             :precision => 10, :scale => 2
    end

    add_index "compras_revenue_accountings", ["capability_id"], :name => "cra_capability_id"
    add_index "compras_revenue_accountings", ["entity_id"], :name => "cra_entity_id"
    add_index "compras_revenue_accountings", ["revenue_nature_id"], :name => "cra_revenue_nature_id"
  end
end

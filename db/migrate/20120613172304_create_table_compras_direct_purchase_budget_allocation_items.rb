class CreateTableComprasDirectPurchaseBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table "compras_direct_purchase_budget_allocation_items" do |t|
      t.integer  "direct_purchase_budget_allocation_id"
      t.integer  "material_id"
      t.string   "brand"
      t.integer  "quantity"
      t.decimal  "unit_price",                           :precision => 10, :scale => 2
      t.datetime "created_at",                                                          :null => false
      t.datetime "updated_at",                                                          :null => false
    end

    add_index "compras_direct_purchase_budget_allocation_items", ["direct_purchase_budget_allocation_id"], :name => "cdpbai_direct_purchase_budget_allocation_id"
    add_index "compras_direct_purchase_budget_allocation_items", ["material_id"], :name => "cdpbai_material_id"
  end
end

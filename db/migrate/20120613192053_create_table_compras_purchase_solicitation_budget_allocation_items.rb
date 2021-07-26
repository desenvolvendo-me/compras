class CreateTableComprasPurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table "compras_purchase_solicitation_budget_allocation_items" do |t|
      t.integer  "purchase_solicitation_budget_allocation_id"
      t.integer  "material_id"
      t.string   "brand"
      t.integer  "quantity"
      t.decimal  "unit_price",                                 :precision => 10, :scale => 2
      t.datetime "created_at",                                                                :null => false
      t.datetime "updated_at",                                                                :null => false
    end

    add_index "compras_purchase_solicitation_budget_allocation_items", ["material_id"], :name => "cpsbai_material_id"
    add_index "compras_purchase_solicitation_budget_allocation_items", ["purchase_solicitation_budget_allocation_id"], :name => "cpsbai_purchase_solicitation_budget_allocation_id"
  end
end

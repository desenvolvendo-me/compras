class CreateTableComprasDirectPurchaseBudgetAllocations < ActiveRecord::Migration
  def change
    create_table "compras_direct_purchase_budget_allocations" do |t|
      t.integer  "direct_purchase_id"
      t.integer  "budget_allocation_id"
      t.datetime "created_at",           :null => false
      t.datetime "updated_at",           :null => false
    end

    add_index "compras_direct_purchase_budget_allocations", ["budget_allocation_id"], :name => "cdpba_budget_allocation_id"
    add_index "compras_direct_purchase_budget_allocations", ["direct_purchase_id"], :name => "cdpba_direct_purchase_id"
  end
end

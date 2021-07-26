class CreateTableComprasPurchaseSolicitationBudgetAllocations < ActiveRecord::Migration
  def change
    create_table "compras_purchase_solicitation_budget_allocations" do |t|
      t.integer  "purchase_solicitation_id"
      t.integer  "budget_allocation_id"
      t.boolean  "blocked",                  :default => false
      t.datetime "created_at",                                  :null => false
      t.datetime "updated_at",                                  :null => false
      t.integer  "expense_nature_id"
    end

    add_index "compras_purchase_solicitation_budget_allocations", ["budget_allocation_id"], :name => "cpsba_budget_allocation_id"
    add_index "compras_purchase_solicitation_budget_allocations", ["expense_nature_id"], :name => "cpsba_expense_nature_id"
    add_index "compras_purchase_solicitation_budget_allocations", ["purchase_solicitation_id"], :name => "cpsba_purchase_solicitation_id"
  end
end

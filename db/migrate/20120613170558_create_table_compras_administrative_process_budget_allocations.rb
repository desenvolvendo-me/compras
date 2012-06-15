class CreateTableComprasAdministrativeProcessBudgetAllocations < ActiveRecord::Migration
  def change
    create_table "compras_administrative_process_budget_allocations" do |t|
      t.integer  "administrative_process_id"
      t.integer  "budget_allocation_id"
      t.decimal  "value",                     :precision => 10, :scale => 2
      t.datetime "created_at",                                               :null => false
      t.datetime "updated_at",                                               :null => false
    end

    add_index "compras_administrative_process_budget_allocations", ["administrative_process_id"], :name => "capba_administrative_process_id"
    add_index "compras_administrative_process_budget_allocations", ["budget_allocation_id"], :name => "capba_budget_allocation_id"
  end
end

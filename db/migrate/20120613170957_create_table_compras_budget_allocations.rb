class CreateTableComprasBudgetAllocations < ActiveRecord::Migration
  def change
    create_table "compras_budget_allocations" do |t|
      t.text     "description"
      t.datetime "created_at",                                                                  :null => false
      t.datetime "updated_at",                                                                  :null => false
      t.decimal  "amount",                    :precision => 10, :scale => 2
      t.integer  "entity_id"
      t.integer  "year"
      t.integer  "budget_structure_id"
      t.integer  "subfunction_id"
      t.integer  "government_program_id"
      t.integer  "government_action_id"
      t.integer  "expense_nature_id"
      t.integer  "capability_id"
      t.text     "goal"
      t.string   "debt_type"
      t.integer  "budget_allocation_type_id"
      t.boolean  "refinancing",                                              :default => false
      t.boolean  "health",                                                   :default => false
      t.boolean  "alienation_appeal",                                        :default => false
      t.boolean  "education",                                                :default => false
      t.boolean  "foresight",                                                :default => false
      t.boolean  "personal",                                                 :default => false
      t.date     "date"
      t.decimal  "value",                     :precision => 10, :scale => 2
      t.string   "kind"
    end

    add_index "compras_budget_allocations", ["budget_allocation_type_id"], :name => "cba_budget_allocation_type_id"
    add_index "compras_budget_allocations", ["budget_structure_id"], :name => "cba_budget_structure_id"
    add_index "compras_budget_allocations", ["capability_id"], :name => "cba_capability_id"
    add_index "compras_budget_allocations", ["entity_id"], :name => "cba_entity_id"
    add_index "compras_budget_allocations", ["expense_nature_id"], :name => "cba_expense_nature_id"
    add_index "compras_budget_allocations", ["government_action_id"], :name => "cba_government_action_id"
    add_index "compras_budget_allocations", ["government_program_id"], :name => "cba_government_program_id"
    add_index "compras_budget_allocations", ["subfunction_id"], :name => "cba_subfunction_id"
  end
end

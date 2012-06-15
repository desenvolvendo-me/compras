class CreateTableComprasBudgetStructures < ActiveRecord::Migration
  def change
    create_table "compras_budget_structures" do |t|
      t.integer  "budget_structure_configuration_id"
      t.string   "tce_code"
      t.string   "description"
      t.string   "acronym"
      t.text     "performance_field"
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
      t.string   "kind"
      t.integer  "administration_type_id"
      t.integer  "code"
      t.integer  "budget_structure_level_id"
      t.integer  "parent_id"
    end

    add_index "compras_budget_structures", ["administration_type_id"], :name => "cbs_administration_type_id"
    add_index "compras_budget_structures", ["budget_structure_configuration_id"], :name => "cbs_budget_structure_configuration_id"
    add_index "compras_budget_structures", ["budget_structure_level_id"], :name => "cbs_budget_structure_level_id"
    add_index "compras_budget_structures", ["parent_id"], :name => "cbs_parent_id"
  end
end

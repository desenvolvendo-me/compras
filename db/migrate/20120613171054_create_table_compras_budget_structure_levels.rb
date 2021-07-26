class CreateTableComprasBudgetStructureLevels < ActiveRecord::Migration
  def change
    create_table "compras_budget_structure_levels" do |t|
      t.integer  "budget_structure_configuration_id"
      t.integer  "level"
      t.string   "description"
      t.integer  "digits"
      t.string   "separator"
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
    end

    add_index "compras_budget_structure_levels", ["budget_structure_configuration_id"], :name => "cbsl_budget_structure_configuration_id"
  end
end

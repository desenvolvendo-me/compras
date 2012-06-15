class CreateTableComprasBudgetStructureConfigurations < ActiveRecord::Migration
  def change
    create_table "compras_budget_structure_configurations" do |t|
      t.integer  "entity_id"
      t.integer  "regulatory_act_id"
      t.string   "description"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end

    add_index "compras_budget_structure_configurations", ["entity_id"], :name => "cbsc_entity_id"
    add_index "compras_budget_structure_configurations", ["regulatory_act_id"], :name => "cbsc_regulatory_act_id"
  end
end

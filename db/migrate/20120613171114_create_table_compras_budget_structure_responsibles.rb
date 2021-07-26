class CreateTableComprasBudgetStructureResponsibles < ActiveRecord::Migration
  def change
    create_table "compras_budget_structure_responsibles" do |t|
      t.integer "budget_structure_id"
      t.integer "responsible_id"
      t.integer "regulatory_act_id"
      t.date    "start_date"
      t.date    "end_date"
      t.string  "status"
    end

    add_index "compras_budget_structure_responsibles", ["budget_structure_id"], :name => "cbsr_budget_structure_id"
    add_index "compras_budget_structure_responsibles", ["regulatory_act_id"], :name => "cbsr_regulatory_act_id"
    add_index "compras_budget_structure_responsibles", ["responsible_id"], :name => "cbsr_responsible_id"
  end
end

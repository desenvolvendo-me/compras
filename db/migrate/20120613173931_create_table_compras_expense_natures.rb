class CreateTableComprasExpenseNatures < ActiveRecord::Migration
  def change
    create_table "compras_expense_natures" do |t|
      t.integer  "entity_id"
      t.integer  "regulatory_act_id"
      t.string   "full_code"
      t.string   "kind"
      t.string   "description"
      t.text     "docket"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
      t.integer  "expense_category_id"
      t.integer  "expense_group_id"
      t.integer  "expense_modality_id"
      t.integer  "expense_element_id"
      t.string   "expense_split"
    end

    add_index "compras_expense_natures", ["entity_id"], :name => "cen_entity_id"
    add_index "compras_expense_natures", ["expense_category_id"], :name => "cen_expense_category_id"
    add_index "compras_expense_natures", ["expense_element_id"], :name => "cen_expense_element_id"
    add_index "compras_expense_natures", ["expense_group_id"], :name => "cen_expense_group_id"
    add_index "compras_expense_natures", ["expense_modality_id"], :name => "cen_expense_modality_id"
    add_index "compras_expense_natures", ["regulatory_act_id"], :name => "cen_regulatory_act_id"
  end
end

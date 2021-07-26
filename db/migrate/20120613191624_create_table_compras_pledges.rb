class CreateTableComprasPledges < ActiveRecord::Migration
  def change
    create_table "compras_pledges" do |t|
      t.integer  "entity_id"
      t.integer  "year"
      t.integer  "management_unit_id"
      t.date     "emission_date"
      t.integer  "budget_allocation_id"
      t.decimal  "value",                    :precision => 10, :scale => 2
      t.integer  "pledge_category_id"
      t.datetime "created_at",                                              :null => false
      t.datetime "updated_at",                                              :null => false
      t.integer  "expense_kind_id"
      t.integer  "pledge_historic_id"
      t.integer  "contract_id"
      t.integer  "licitation_modality_id"
      t.text     "description"
      t.integer  "reserve_fund_id"
      t.string   "material_kind"
      t.integer  "founded_debt_contract_id"
      t.string   "pledge_type"
      t.integer  "licitation_process_id"
      t.integer  "provider_id"
      t.integer  "code"
    end

    add_index "compras_pledges", ["budget_allocation_id"], :name => "cp_budget_allocation_id"
    add_index "compras_pledges", ["code", "entity_id", "year"], :name => "cp_year"
    add_index "compras_pledges", ["contract_id"], :name => "cp_contract_id"
    add_index "compras_pledges", ["entity_id"], :name => "cp_entity_id"
    add_index "compras_pledges", ["expense_kind_id"], :name => "cp_expense_kind_id"
    add_index "compras_pledges", ["founded_debt_contract_id"], :name => "cp_founded_debt_contract_id"
    add_index "compras_pledges", ["licitation_modality_id"], :name => "cp_licitation_modality_id"
    add_index "compras_pledges", ["licitation_process_id"], :name => "cp_licitation_process_id"
    add_index "compras_pledges", ["management_unit_id"], :name => "cp_management_unit_id"
    add_index "compras_pledges", ["pledge_category_id"], :name => "cp_pledge_category_id"
    add_index "compras_pledges", ["pledge_historic_id"], :name => "cp_pledge_historic_id"
    add_index "compras_pledges", ["provider_id"], :name => "cp_provider_id"
    add_index "compras_pledges", ["reserve_fund_id"], :name => "cp_reserve_fund_id"
  end
end

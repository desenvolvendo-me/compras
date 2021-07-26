class CreateTableComprasJudgmentCommissionAdvices < ActiveRecord::Migration
  def change
    create_table "compras_judgment_commission_advices" do |t|
      t.integer  "licitation_process_id"
      t.integer  "licitation_commission_id"
      t.integer  "minutes_number"
      t.integer  "year"
      t.integer  "judgment_sequence"
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.date     "judgment_start_date"
      t.time     "judgment_start_time"
      t.date     "judgment_end_date"
      t.time     "judgment_end_time"
      t.text     "companies_minutes"
      t.text     "companies_documentation_minutes"
      t.text     "justification_minutes"
      t.text     "judgment_minutes"
    end

    add_index "compras_judgment_commission_advices", ["licitation_commission_id"], :name => "cjca_licitation_commission_id"
    add_index "compras_judgment_commission_advices", ["licitation_process_id"], :name => "cjca_licitation_process_id"
    add_index "compras_judgment_commission_advices", ["minutes_number", "year"], :name => "cjca_year"
  end
end

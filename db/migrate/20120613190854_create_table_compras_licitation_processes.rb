class CreateTableComprasLicitationProcesses < ActiveRecord::Migration
  def change
    create_table "compras_licitation_processes" do |t|
      t.integer  "administrative_process_id"
      t.integer  "capability_id"
      t.integer  "payment_method_id"
      t.integer  "year"
      t.date     "process_date"
      t.decimal  "caution_value",             :precision => 10, :scale => 2
      t.string   "legal_advice"
      t.date     "legal_advice_date"
      t.date     "contract_date"
      t.integer  "contract_expiration"
      t.text     "observations"
      t.datetime "created_at",                                               :null => false
      t.datetime "updated_at",                                               :null => false
      t.integer  "process"
      t.integer  "licitation_number"
      t.string   "modality"
      t.date     "envelope_delivery_date"
      t.time     "envelope_delivery_time"
      t.date     "envelope_opening_date"
      t.time     "envelope_opening_time"
      t.date     "ratification_date"
      t.date     "adjudication_date"
      t.string   "pledge_type"
      t.string   "type_of_calculation"
      t.integer  "period"
      t.string   "period_unit"
      t.integer  "expiration"
      t.string   "expiration_unit"
      t.integer  "readjustment_index_id"
      t.integer  "judgment_form_id"
    end

    add_index "compras_licitation_processes", ["administrative_process_id"], :name => "clp_administrative_process_id"
    add_index "compras_licitation_processes", ["capability_id"], :name => "clp_capability_id"
    add_index "compras_licitation_processes", ["judgment_form_id"], :name => "clp_judgment_form_id"
    add_index "compras_licitation_processes", ["licitation_number", "modality", "year"], :name => "clp_year"
    add_index "compras_licitation_processes", ["payment_method_id"], :name => "clp_payment_method_id"
    add_index "compras_licitation_processes", ["process", "year"], :name => "clpr_year"
    add_index "compras_licitation_processes", ["readjustment_index_id"], :name => "clp_readjustment_index_id"
  end
end

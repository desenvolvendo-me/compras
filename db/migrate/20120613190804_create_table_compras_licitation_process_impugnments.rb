class CreateTableComprasLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_impugnments" do |t|
      t.integer  "licitation_process_id"
      t.date     "impugnment_date"
      t.string   "related"
      t.integer  "person_id"
      t.text     "valid_reason"
      t.string   "situation",                  :default => "Pendente"
      t.date     "judgment_date"
      t.text     "observation"
      t.datetime "created_at",                                         :null => false
      t.datetime "updated_at",                                         :null => false
      t.date     "new_envelope_delivery_date"
      t.time     "new_envelope_delivery_time"
      t.date     "new_envelope_opening_date"
      t.time     "new_envelope_opening_time"
    end

    add_index "compras_licitation_process_impugnments", ["licitation_process_id"], :name => "clpi_licitation_process_id"
    add_index "compras_licitation_process_impugnments", ["person_id"], :name => "clpi_person_id"
  end
end

class CreateTableComprasLicitationProcessAppeals < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_appeals" do |t|
      t.integer  "licitation_process_id"
      t.date     "appeal_date"
      t.string   "related"
      t.integer  "person_id"
      t.text     "valid_reason"
      t.text     "licitation_committee_opinion"
      t.string   "situation"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.date     "new_envelope_opening_date"
      t.time     "new_envelope_opening_time"
    end

    add_index "compras_licitation_process_appeals", ["licitation_process_id"], :name => "clpa_licitation_process_id"
    add_index "compras_licitation_process_appeals", ["person_id"], :name => "clpa_person_id"
  end
end

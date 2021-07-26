class CreateTableComprasAdministrativeProcesses < ActiveRecord::Migration
  def change
    create_table "compras_administrative_processes" do |t|
      t.integer  "process"
      t.integer  "year"
      t.date     "date"
      t.string   "protocol"
      t.string   "modality"
      t.string   "item"
      t.string   "object_type"
      t.text     "description"
      t.integer  "responsible_id"
      t.string   "status"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
      t.integer  "judgment_form_id"
    end

    add_index "compras_administrative_processes", ["judgment_form_id"], :name => "cap_judgment_form_id"
    add_index "compras_administrative_processes", ["process", "year"], :name => "cap_process_year", :unique => true
    add_index "compras_administrative_processes", ["responsible_id"], :name => "cap_responsible_id"
  end
end

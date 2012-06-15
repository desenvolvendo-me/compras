class CreateTableComprasReserveFunds < ActiveRecord::Migration
  def change
    create_table "compras_reserve_funds" do |t|
      t.integer  "year"
      t.integer  "entity_id"
      t.integer  "budget_allocation_id"
      t.decimal  "value",                      :precision => 10, :scale => 2
      t.datetime "created_at",                                                :null => false
      t.datetime "updated_at",                                                :null => false
      t.integer  "reserve_allocation_type_id"
      t.integer  "licitation_modality_id"
      t.string   "status"
      t.date     "date"
      t.string   "licitation_number"
      t.string   "licitation_year"
      t.string   "process_number"
      t.string   "process_year"
      t.text     "reason"
      t.integer  "provider_id"
    end

    add_index "compras_reserve_funds", ["budget_allocation_id"], :name => "crf_budget_allocation_id"
    add_index "compras_reserve_funds", ["entity_id"], :name => "crf_entity_id"
    add_index "compras_reserve_funds", ["licitation_modality_id"], :name => "crf_licitation_modality_id"
    add_index "compras_reserve_funds", ["provider_id"], :name => "crf_provider_id"
    add_index "compras_reserve_funds", ["reserve_allocation_type_id"], :name => "crf_reserve_allocation_type_id"
  end
end

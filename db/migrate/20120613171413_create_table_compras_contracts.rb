class CreateTableComprasContracts < ActiveRecord::Migration
  def change
    create_table "compras_contracts" do |t|
      t.integer  "year"
      t.integer  "entity_id"
      t.string   "contract_number"
      t.string   "process_number"
      t.date     "signature_date"
      t.date     "end_date"
      t.text     "description"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
      t.string   "kind"
    end

    add_index "compras_contracts", ["entity_id"], :name => "cct_entity_id"
  end
end

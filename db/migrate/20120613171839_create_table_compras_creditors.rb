class CreateTableComprasCreditors < ActiveRecord::Migration
  def change
    create_table "compras_creditors" do |t|
      t.integer  "person_id"
      t.integer  "occupation_classification_id"
      t.boolean  "municipal_public_administration", :default => false
      t.boolean  "autonomous",                      :default => false
      t.string   "social_identification_number"
      t.integer  "company_size_id"
      t.boolean  "choose_simple",                   :default => false
      t.integer  "main_cnae_id"
      t.datetime "created_at",                                         :null => false
      t.datetime "updated_at",                                         :null => false
      t.date     "contract_start_date"
    end

    add_index "compras_creditors", ["company_size_id"], :name => "ccr_company_size_id"
    add_index "compras_creditors", ["main_cnae_id"], :name => "cc_main_cnae_id"
    add_index "compras_creditors", ["occupation_classification_id"], :name => "cc_occupation_classification_id"
    add_index "compras_creditors", ["person_id"], :name => "ccr_person_id"
  end
end

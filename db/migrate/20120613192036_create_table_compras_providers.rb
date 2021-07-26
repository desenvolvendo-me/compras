class CreateTableComprasProviders < ActiveRecord::Migration
  def change
    create_table "compras_providers" do |t|
      t.integer  "person_id"
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
      t.integer  "agency_id"
      t.integer  "legal_nature_id"
      t.integer  "cnae_id"
      t.date     "registration_date"
      t.string   "bank_account"
      t.string   "crc_number"
      t.date     "crc_registration_date"
      t.date     "crc_expiration_date"
      t.date     "crc_renewal_date"
      t.integer  "economic_registration_id"
    end

    add_index "compras_providers", ["agency_id"], :name => "cp_agency_id"
    add_index "compras_providers", ["cnae_id"], :name => "cp_cnae_id"
    add_index "compras_providers", ["economic_registration_id"], :name => "cp_economic_registration_id"
    add_index "compras_providers", ["legal_nature_id"], :name => "cp_legal_nature_id"
    add_index "compras_providers", ["person_id"], :name => "cpro_person_id"
  end
end

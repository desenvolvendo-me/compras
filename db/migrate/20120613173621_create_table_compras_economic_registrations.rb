class CreateTableComprasEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table "compras_economic_registrations" do |t|
      t.string   "registration"
      t.integer  "person_id"
      t.integer  "issqn_classification_id"
      t.integer  "branch_activity_id"
      t.boolean  "location_operation_fee",      :default => false
      t.boolean  "special_schedule_fee",        :default => false
      t.boolean  "publicity_fee",               :default => false
      t.boolean  "sanitary_permit_fee",         :default => false
      t.boolean  "land_use_fee",                :default => false
      t.integer  "working_hour_id"
      t.integer  "accountant_id"
      t.datetime "created_at",                                     :null => false
      t.datetime "updated_at",                                     :null => false
      t.boolean  "active",                      :default => true
      t.string   "correspondence_address_type"
    end

    add_index "compras_economic_registrations", ["accountant_id"], :name => "cer_accountant_id"
    add_index "compras_economic_registrations", ["branch_activity_id"], :name => "cer_branch_activity_id"
    add_index "compras_economic_registrations", ["issqn_classification_id"], :name => "cer_issqn_classification_id"
    add_index "compras_economic_registrations", ["person_id"], :name => "cer_person_id"
    add_index "compras_economic_registrations", ["working_hour_id"], :name => "cer_working_hour_id"
  end
end

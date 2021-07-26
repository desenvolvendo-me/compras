class MigrateAccountingCapabilities < ActiveRecord::Migration
  def change
    if Rails.env.development? || Rails.env.test?
      create_table "accounting_capability_destinations" do |t|
        t.string   "use"
        t.string   "group"
        t.integer  "specification"
        t.string   "description"
        t.string   "kind"
        t.datetime "created_at",    :null => false
        t.datetime "updated_at",    :null => false
      end

      create_table "accounting_capability_allocation_details" do |t|
        t.string   "description"
        t.datetime "created_at",  :null => false
        t.datetime "updated_at",  :null => false
      end

      create_table "accounting_capability_destination_details" do |t|
        t.integer  "capability_destination_id"
        t.integer  "capability_allocation_detail_id"
        t.string   "status"
        t.datetime "created_at",                      :null => false
        t.datetime "updated_at",                      :null => false
      end

      create_table "accounting_capability_sources" do |t|
        t.integer  "code"
        t.string   "name"
        t.text     "specification"
        t.string   "source"
        t.datetime "created_at",    :null => false
        t.datetime "updated_at",    :null => false
      end

      create_table "accounting_tce_specification_capabilities" do |t|
        t.string   "description"
        t.integer  "capability_source_id"
        t.integer  "application_code_id"
        t.datetime "created_at",           :null => false
        t.datetime "updated_at",           :null => false
      end
    end
  end
end

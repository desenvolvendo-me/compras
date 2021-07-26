class DropAccountingReserveFunds < ActiveRecord::Migration
  def up
    if Rails.env.development? || Rails.env.test?
      drop_table :accounting_reserve_funds
    end
  end

  def down
    if Rails.env.development? || Rails.env.test?
      create_table "accounting_reserve_funds" do |t|
        t.integer  "budget_allocation_id"
        t.decimal  "value",                      :precision => 10, :scale => 2
        t.datetime "created_at",                 :null => false
        t.datetime "updated_at",                 :null => false
        t.integer  "reserve_allocation_type_id"
        t.string   "status"
        t.date     "date"
        t.text     "reason"
        t.integer  "creditor_id"
        t.integer  "descriptor_id"
        t.integer  "licitation_process_id"
        t.integer  "modality"
        t.string   "licitation_process"
      end
    end
  end
end

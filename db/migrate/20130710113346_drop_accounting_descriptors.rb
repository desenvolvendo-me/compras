class DropAccountingDescriptors < ActiveRecord::Migration
  def up
    if Rails.env.development? || Rails.env.test?
      drop_table :accounting_descriptors
    end
  end

  def down
    if Rails.env.development? || Rails.env.test?
      create_table "accounting_descriptors" do |t|
        t.integer  "entity_id"
        t.datetime "created_at", :null => false
        t.datetime "updated_at", :null => false
        t.date     "period"
        t.integer  "year"
      end
    end
  end
end

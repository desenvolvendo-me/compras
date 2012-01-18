class CreateRevenueParcelDebtSettings < ActiveRecord::Migration
  def change
    create_table :parcel_debt_settings_revenues, :id => false do |t|
      t.references :parcel_debt_setting, :revenue
    end
    
    add_index :parcel_debt_settings_revenues, :parcel_debt_setting_id
    add_index :parcel_debt_settings_revenues, :revenue_id
    add_index :parcel_debt_settings_revenues, [:parcel_debt_setting_id, :revenue_id], :unique => true, :name => :parcel_debt_setting_revenue
    add_foreign_key :parcel_debt_settings_revenues, :parcel_debt_settings
    add_foreign_key :parcel_debt_settings_revenues, :revenues
  end
end

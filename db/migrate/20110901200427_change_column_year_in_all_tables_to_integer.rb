class ChangeColumnYearInAllTablesToInteger < ActiveRecord::Migration
  def up
    change_column :economic_registration_settings, :year, :integer
    change_column :property_settings, :year, :integer
    change_column :request_public_services, :year, :integer
    change_column :section_streets, :base_year, :integer
    change_column :splittings, :year, :integer
    change_column :street_services, :year, :integer
    change_column :sub_revenue_parcels, :year, :integer
    change_column :system_settings, :year, :integer
    change_column :urban_services, :year, :integer
    change_column :active_debts, :year, :integer
    change_column :active_debts, :book_year, :integer
    change_column :active_debts, :registration_year, :integer
  end

  def down
    change_column :economic_registration_settings, :year, :string
    change_column :property_settings, :year, :string
    change_column :request_public_services, :year, :string
    change_column :section_streets, :base_year, :string
    change_column :splittings, :year, :string
    change_column :street_services, :year, :string
    change_column :sub_revenue_parcels, :year, :string
    change_column :system_settings, :year, :string
    change_column :urban_services, :year, :string
    change_column :active_debts, :year, :string
    change_column :active_debts, :book_year, :string
    change_column :active_debts, :registration_year, :string
  end
end

class CreateParcelDebtSettings < ActiveRecord::Migration
  def change
    create_table :parcel_debt_settings do |t|
      t.string :name
      t.references :parcel_law
      t.date :start_date
      t.date :end_date
      t.integer :max_parcels
      t.integer :days_first_due_date
      t.boolean :can_update_due_dates
      t.boolean :due_date_in_week_days
      t.boolean :discount
      t.boolean :amnesty_remains
      t.decimal :company_min_value, :precision => 10, :scale => 2
      t.decimal :company_max_value, :precision => 10, :scale => 2
      t.decimal :individual_min_value, :precision => 10, :scale => 2
      t.decimal :individual_max_value, :precision => 10, :scale => 2
      t.boolean :calculate_interest
      t.boolean :calculate_fine
      t.boolean :calculate_fine_over_interest_plus_value
      t.boolean :interest_financing
      t.boolean :indexation_pre_set

      t.timestamps
    end
    add_index :parcel_debt_settings, :parcel_law_id
    add_foreign_key :parcel_debt_settings, :parcel_laws
  end
end

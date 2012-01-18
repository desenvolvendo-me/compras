class CreateDebtDueDateProrrogations < ActiveRecord::Migration
  def change
    create_table :debt_due_date_prolongations do |t|
      t.integer :year
      t.references :revenue
      t.references :property
      t.string :parcel_range
      t.string :person_range
      t.string :interval_type
      t.integer :interval_number

      t.timestamps
    end
    add_index :debt_due_date_prolongations, :revenue_id
    add_foreign_key :debt_due_date_prolongations, :revenues

    add_index :debt_due_date_prolongations, :property_id
    add_foreign_key :debt_due_date_prolongations, :properties
  end
end

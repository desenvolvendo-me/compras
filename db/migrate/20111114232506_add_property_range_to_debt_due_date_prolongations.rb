class AddPropertyRangeToDebtDueDateProlongations < ActiveRecord::Migration
  def change
    add_column :debt_due_date_prolongations, :property_range, :string
  end
end

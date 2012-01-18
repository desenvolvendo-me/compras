class RemovePropertyIdFromDebtDueDateProlongations < ActiveRecord::Migration
  def change
    remove_column :debt_due_date_prolongations, :property_id
  end
end

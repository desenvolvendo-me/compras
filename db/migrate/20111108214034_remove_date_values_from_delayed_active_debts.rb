class RemoveDateValuesFromDelayedActiveDebts < ActiveRecord::Migration
  def change
    remove_column :delayed_active_debts, :date_values
  end
end

class AddEnrollmentDateToDelayedActiveDebts < ActiveRecord::Migration
  def change
    add_column :delayed_active_debts, :enrollment_date, :date
  end
end

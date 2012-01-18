class AddEnrolledToActiveDebts < ActiveRecord::Migration
  def change
    add_column :active_debts, :enrolled, :boolean, :default => false
  end
end

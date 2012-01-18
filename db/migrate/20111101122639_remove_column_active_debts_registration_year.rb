class RemoveColumnActiveDebtsRegistrationYear < ActiveRecord::Migration
  def change
    remove_column :active_debts, :registration_year
  end
end

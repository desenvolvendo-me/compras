class AddIndexOnYearToActiveDebts < ActiveRecord::Migration
  def change
    add_index :active_debts, :year
  end
end

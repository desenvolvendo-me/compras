class RemoveBookFromActiveDebt < ActiveRecord::Migration
  def change
    remove_column :active_debts, :book
    remove_column :active_debts, :book_year
    remove_column :active_debts, :sheet
    remove_column :active_debts, :position
    remove_column :active_debts, :registration
    remove_column :active_debts, :registration_date
  end

end

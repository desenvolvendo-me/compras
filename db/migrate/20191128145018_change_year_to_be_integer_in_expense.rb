class ChangeYearToBeIntegerInExpense < ActiveRecord::Migration
  def change
    remove_column :compras_expenses, :year
    add_column :compras_expenses, :year, :integer
  end
end

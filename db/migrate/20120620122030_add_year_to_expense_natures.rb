class AddYearToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :compras_expense_natures, :year, :integer
  end
end

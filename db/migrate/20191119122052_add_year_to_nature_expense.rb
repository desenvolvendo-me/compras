class AddYearToNatureExpense < ActiveRecord::Migration
  def up
    add_column :compras_nature_expenses,
               :year, :integer
  end

  def down
    remove_column :compras_nature_expenses,
                  :year
  end
end

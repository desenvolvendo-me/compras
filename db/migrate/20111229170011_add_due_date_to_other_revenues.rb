class AddDueDateToOtherRevenues < ActiveRecord::Migration
  def change
    add_column :other_revenues, :due_date, :date
  end
end

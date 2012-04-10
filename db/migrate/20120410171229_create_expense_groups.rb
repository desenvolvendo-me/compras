class CreateExpenseGroups < ActiveRecord::Migration
  def change
    create_table :expense_groups do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end

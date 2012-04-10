class CreateExpenseElements < ActiveRecord::Migration
  def change
    create_table :expense_elements do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end

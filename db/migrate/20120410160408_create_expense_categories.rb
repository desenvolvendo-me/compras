class CreateExpenseCategories < ActiveRecord::Migration
  def change
    create_table :expense_categories do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end

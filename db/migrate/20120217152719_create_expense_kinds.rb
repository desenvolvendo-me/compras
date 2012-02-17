class CreateExpenseKinds < ActiveRecord::Migration
  def change
    create_table :expense_kinds do |t|
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end

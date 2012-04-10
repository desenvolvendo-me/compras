class CreateExpenseModalities < ActiveRecord::Migration
  def change
    create_table :expense_modalities do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end

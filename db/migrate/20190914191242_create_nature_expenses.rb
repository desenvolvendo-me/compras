class CreateNatureExpenses < ActiveRecord::Migration
  def change
    create_table :compras_nature_expenses do |t|
      t.string :description
      t.string :nature

      t.timestamps
    end
  end
end

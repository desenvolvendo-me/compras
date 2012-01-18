class CreateSubRevenues < ActiveRecord::Migration
  def change
    create_table :sub_revenues do |t|
      t.decimal :original_value, :precision => 10, :scale => 2
      t.decimal :converted_value, :precision => 10, :scale => 2
      t.decimal :due_value, :precision => 10, :scale => 2
      t.references :revenue
      t.references :active_debt

      t.timestamps
    end
    add_index :sub_revenues, :revenue_id
    add_index :sub_revenues, :active_debt_id
    add_foreign_key :sub_revenues, :revenues
    add_foreign_key :sub_revenues, :active_debts
  end
end

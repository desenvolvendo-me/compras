class CreateActiveDebtsRevenues < ActiveRecord::Migration
  def change
    create_table :active_debts_revenues, :id => false do |t|
      t.references :active_debt, :revenue
    end

    add_index :active_debts_revenues, :active_debt_id
    add_index :active_debts_revenues, :revenue_id
    add_index :active_debts_revenues, [:revenue_id, :active_debt_id]
    add_foreign_key :active_debts_revenues, :revenues
    add_foreign_key :active_debts_revenues, :active_debts

  end
end

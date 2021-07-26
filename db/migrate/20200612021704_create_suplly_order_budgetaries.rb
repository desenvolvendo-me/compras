class CreateSupllyOrderBudgetaries < ActiveRecord::Migration
  def change
    create_table :compras_supply_order_budgetaries do |t|
      t.integer :supply_order_id
      t.integer :expense_id
      t.integer :secretary_id
      t.decimal :value, precision: 15, scale: 2

      t.timestamps
    end

    add_index :compras_supply_order_budgetaries, :supply_order_id
    add_foreign_key :compras_supply_order_budgetaries, :compras_supply_orders,
                    column: :supply_order_id

    add_index :compras_supply_order_budgetaries, :expense_id
    add_foreign_key :compras_supply_order_budgetaries, :compras_expenses,
                    column: :expense_id

    add_index :compras_supply_order_budgetaries, :secretary_id
    add_foreign_key :compras_supply_order_budgetaries, :compras_secretaries,
                    column: :secretary_id
  end

end

class AddExpenseToSupplyOrders < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :expense_id, :integer

    add_index :compras_supply_orders, :expense_id
    add_foreign_key :compras_supply_orders, :compras_expenses,
                    column: :expense_id
  end
end

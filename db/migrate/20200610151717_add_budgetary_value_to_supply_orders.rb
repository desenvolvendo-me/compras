class AddBudgetaryValueToSupplyOrders < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :budgetary_value, :decimal, precision: 15, scale: 2
  end
end

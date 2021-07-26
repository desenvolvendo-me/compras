class AddYearToSupplyOrders < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :year, :integer
  end
end

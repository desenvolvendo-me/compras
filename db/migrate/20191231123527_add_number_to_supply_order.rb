class AddNumberToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :number, :string
  end
end

class AddValueToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :value, :decimal,
                  :precision => 10, :scale => 2, :default => 0.0
  end
end
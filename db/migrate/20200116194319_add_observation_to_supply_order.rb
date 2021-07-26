class AddObservationToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :observation, :text
  end
end

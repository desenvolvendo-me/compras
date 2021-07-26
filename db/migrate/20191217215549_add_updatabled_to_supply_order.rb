class AddUpdatabledToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :updatabled, :boolean, default: false
  end
end
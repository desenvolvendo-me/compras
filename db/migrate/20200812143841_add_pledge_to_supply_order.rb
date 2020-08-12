class AddPledgeToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :pledge, :string
  end
end

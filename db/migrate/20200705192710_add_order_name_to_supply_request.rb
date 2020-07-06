class AddOrderNameToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :order_name, :string
  end
end

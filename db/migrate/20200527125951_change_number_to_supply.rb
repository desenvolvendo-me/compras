class ChangeNumberToSupply < ActiveRecord::Migration
  def change
    SupplyRequest.update_all(number: nil)
    SupplyOrder.update_all(number: nil)

    change_column :compras_supply_requests, :number, :integer
    change_column :compras_supply_orders, :number, :integer
  end

end

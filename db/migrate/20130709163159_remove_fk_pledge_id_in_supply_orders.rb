class RemoveFkPledgeIdInSupplyOrders < ActiveRecord::Migration
  def change
    #remove_foreign_key :compras_supply_orders, column: :pledge_id
  end
end

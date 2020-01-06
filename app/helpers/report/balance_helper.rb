module Report::BalanceHelper

  def self.get_balance(contract, item)
    balance = {"total" => 0, "balance" => 0}

    supply_orders = SupplyOrder.joins(:contract, :items)
    supply_orders = supply_orders.where("compras_supply_order_items.material_id = #{item.material.id}")
    supply_orders = supply_orders.where(contract_id: contract.id)


    total = supply_orders.sum(:quantity) if supply_orders.any?

    balance["total"] = total.to_i
    balance["balance"] = item.quantity - total.to_i

    balance
  end

end
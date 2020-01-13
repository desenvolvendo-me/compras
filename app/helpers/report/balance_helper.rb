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

  def self.get_quantity_item_licitation(licitation_process, material)
    licitation_process.items.where(material_id: material.id).last.quantity
  end

  def self.get_quantity_bid(licitation_process)
    material_ids = []
    licitation_process.supply_orders.each do |supply_order|
      material_ids = supply_order.items.pluck(:material_id)
    end

    licitation_process.items.where(material_id: material_ids.uniq).sum(:quantity)
  end

end
module ContractsHelper
  def contract_termination_path
    # if resource.allow_termination?
    #   new_contract_termination_path(:contract_id => resource.id)
    # else
    #   edit_contract_termination_path(resource.contract_termination, :contract_id => resource.id)
    # end
  end

  def sum_value_items_supply_order(supply_order)
    value = 0

    supply_order.items.each do |item|
      licitation_process_items = supply_order.licitation_process.items.where(material_id: item.material_id)

      item_value = licitation_process_items.first.unit_price if licitation_process_items.any?
      item_total = supply_order.items.where(material_id: item.material_id).sum(:quantity)

      value += item_value.to_f * item_total.to_f
    end

    value
  end

  def get_balance(contract, material_id)
    supply_orders = SupplyOrder.joins(:contract, :items)
    supply_orders = supply_orders.where("compras_supply_order_items.material_id = ?", material_id)
    supply_orders = supply_orders.where(contract_id: contract.id)

    total_provided = supply_orders.sum(:quantity) if supply_orders.any?
    total_bid = contract.licitation_process.items.where(material_id: material_id).sum(:quantity)

    balance = total_bid.to_i - total_provided.to_i
    balance
  end

  def get_quantity_item_supply_order(contract, material_id)
    quantity_provided = contract.supply_orders.joins(:items).where(" compras_supply_order_items.material_id = ?", material_id).sum("compras_supply_order_items.quantity")
    quantity_provided.to_i
  end
end

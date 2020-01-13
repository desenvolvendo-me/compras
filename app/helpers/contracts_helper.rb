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
      item_value = supply_order.licitation_process.items.where(material_id: item.material_id).first.unit_price
      item_total = supply_order.items.where(material_id: item.material_id).sum(:quantity)
      value += item_value * item_total
    end

    value
  end
end

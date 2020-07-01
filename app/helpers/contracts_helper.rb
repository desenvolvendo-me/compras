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

  def get_saldo_material licitation_process, purchase_solicitation, material, contract
    ContractItemBalance.where(purchase_process_id: licitation_process, material_id: material,
                              contract_id: contract, purchase_solicitation_id: purchase_solicitation).sum(:quantity)
  end
end

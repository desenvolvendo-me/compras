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
    quantity_autorized = PurchaseSolicitation.quantity_autorized(licitation_process, purchase_solicitation, material, contract) || 0
    objects = PurchaseSolicitation.joins(:list_purchase_solicitations).where{ list_purchase_solicitations.licitation_process_id.eq(8) }.where{ list_purchase_solicitations.purchase_solicitation_id.not_eq(71) }
    quantity_delivered = objects.joins(:items).where("compras_purchase_solicitation_items.material_id = ?", material.id).sum(:quantity).to_f || 0

    quantity_autorized - quantity_delivered
  end
end

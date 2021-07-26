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


  def get_quantity_item_supply_order(contract, material_id, p_solicitation=nil)
    quantity_provided = contract.supply_orders.joins(:items)
    quantity_provided = quantity_provided.where('compras_supply_orders.purchase_solicitation_id = ?', p_solicitation.id) if p_solicitation.present?
    quantity_provided = quantity_provided.where("compras_supply_order_items.material_id = ?", material_id).sum("compras_supply_order_items.quantity")
    quantity_provided.to_i
  end

  def material_vl_unitary licitation_process, material
    if licitation_process.type_of_purchase == 'licitation'
      result = LicitationProcessRatificationItem.by_licitation_process_and_material(licitation_process.id, material.id)
      result&.last&.price || 0
    else
      result = LicitationProcessRatificationItem
                   .joins(:licitation_process_ratification).joins(purchase_process_item:[:material])
                   .where(compras_licitation_process_ratifications:{licitation_process_id: licitation_process.id})
                   .where(unico_materials:{id: material.id})

      result&.last&.unit_price || 0
    end
  end

  def qtd_requested p_solicitation_id, material, licitation_process
    lots = PurchaseProcessItem.where { material_id.eq(material.id) }.where { licitation_process_id.eq(licitation_process) }.pluck(:lot)

    qtd = PurchaseSolicitationItem.joins { purchase_solicitation }
              .where { purchase_solicitation.id.eq(p_solicitation_id) }
              .where { material_id.eq(material.id) }
              .where { lot.in(lots) }&.last&.quantity

    qtd || 0
  end

  def ordered_purchasses purchase_solicitations
    PurchaseSolicitationItem.includes(:material).where(id: purchase_solicitations.map { |p| p.id}).order("unico_materials.description")
  end

  def get_supply_order_invoices supply_orders
    Invoice.where(supply_order_id: supply_orders.pluck(:id)).order('number, date, value DESC')
  end

  def find_or_init_consumption purchase_solicitation, parent, materialID
    item = purchase_solicitation.items.where(material_id: materialID).last
    consumption = parent.consumption_minutes.where(purchase_solicitation_item_id: item.id)

    return consumption unless consumption.blank?


    ContractConsumptionMinute.new({purchase_solicitation_item_id: item.id, contract_id: parent.id})

  end
end

module Report::ContractPerResourceSourceHelper
  def self.sum_value_items_supply_order(supply_order)
    value = 0

    supply_order.items.each do |item|
      licitation_process_items = supply_order.licitation_process.items.where(material_id: item.material_id)

      item_value = licitation_process_items.first.unit_price if licitation_process_items.any?
      item_total = supply_order.items.where(material_id: item.material_id).sum(:quantity)

      value += item_value.to_f * item_total.to_f
    end

    value
  end

  def self.get_supply_orders contract, financial
    contract.supply_orders.joins{ purchase_solicitation }.joins{ purchase_solicitation.department }
        .where{ purchase_solicitation.department.secretary_id.eq(financial.secretary_id) }
  end
end
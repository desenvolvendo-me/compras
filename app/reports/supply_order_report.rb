class SupplyOrderReport < Report
  attr_accessor :supply_order_id

  def supply_order
    SupplyOrder.find(self.supply_order_id.to_i)
  end

  def prefecture
    Prefecture.last.name
  end

  def creditor
    supply_order.creditor.person.name
  end

  def get_delivery_location
    if supply_order.licitation_process.purchase_solicitations.blank? || supply_order.licitation_process.purchase_solicitations.first.purchase_solicitation.delivery_location.nil?
      "Não Informado"
    else
      supply_order.licitation_process.purchase_solicitations.first.purchase_solicitation.delivery_location
    end
  end

  def licitation_process
    supply_order.licitation_process
  end

end

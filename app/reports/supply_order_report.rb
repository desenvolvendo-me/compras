class SupplyOrderReport < Report
  attr_accessor :supply_order_id

  def supply_order
    SupplyOrder.find(self.supply_order_id.to_i)
  end

  def items
    SupplyOrder.find(self.supply_order_id.to_i).items
  end

  def prefecture
    Prefecture.last.name
  end

  def creditor
    supply_order.creditor.person.name unless supply_order.creditor.nil? || supply_order.creditor.person.nil?
  end

  def number
    supply_order.number
  end

  def supply_budgetaries
    supply_order.supply_budgetaries
  end

  def billing
    supply_order.purchase_solicitation.try(:department).try(:purchasing_unit).try(:billing)
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

  def contract
    supply_order.contract
  end

end

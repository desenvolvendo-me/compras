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

  def licitation_process
    supply_order.licitation_process
  end

end

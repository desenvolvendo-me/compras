class SupplyRequestReport < Report
  attr_accessor :supply_request_id

  def supply_request
    SupplyRequest.find(self.supply_request_id.to_i)
  end

  def items
    SupplyRequest.find(self.supply_request_id.to_i).items
  end

  def prefecture
    Prefecture.last.name
  end

  def creditor
    supply_request.creditor.person.name unless supply_request.creditor.nil? || supply_request.creditor.person.nil?
  end

  def get_delivery_location
    if supply_request.licitation_process.purchase_solicitations.blank? || supply_request.licitation_process.purchase_solicitations.first.purchase_solicitation.delivery_location.nil?
      "Não Informado"
    else
      supply_request.licitation_process.purchase_solicitations.first.purchase_solicitation.delivery_location
    end
  end

  def licitation_process
    supply_request.licitation_process
  end

end

class SupplyRequestReport < Report

  attr_accessor :supply_request_id, :current_user_id

  def supply_request
    SupplyRequest.find(self.supply_request_id.to_i)
  end

  def items
    SupplyRequest.find(self.supply_request_id.to_i).items
  end

  def prefecture
    Prefecture.last.name
  end

  def department
    supply_request.purchase_solicitation.department
  end

  def department_ṕerson
    User.find(self.current_user_id.to_i).name
  end

  def creditor
    supply_request.creditor.person.name unless supply_request.creditor.nil? || supply_request.creditor.person.nil?
  end

  def number
    supply_request.number
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

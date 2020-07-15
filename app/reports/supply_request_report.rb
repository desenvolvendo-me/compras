class SupplyRequestReport < Report

  attr_accessor :supply_request_id, :current_user_id, :approv, :secretary

  def supply_request
    SupplyRequest.find(self.supply_request_id.to_i)
  end

  def items
    SupplyRequest.find(self.supply_request_id.to_i).items
  end

  def prefecture
    Prefecture.last.name
  end

  def requesting_department
    supply_request.department.to_s.mb_chars.upcase unless supply_request.department.nil?
  end

  def department
    supply_request.purchase_solicitation.department unless supply_request.purchase_solicitation.nil?
  end

  def department_person
    sp = SupplyRequest.find(self.supply_request_id.to_i)
    sp.user.authenticable.to_s.mb_chars.upcase unless sp.user.nil?
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

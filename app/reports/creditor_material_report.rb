class CreditorMaterialReport < Report

  attr_accessor :licitation_process_id, :contract_id, :creditor_id

  def materials
    if licitation_process_id && contract_id && creditor_id
      Material.material_of_supply_request([licitation_process_id, contract_id, creditor_id]).order(:description)
    end
  end

  def creditor
    Creditor.find(creditor_id)
  end

end
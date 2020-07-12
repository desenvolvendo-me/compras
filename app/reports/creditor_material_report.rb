class CreditorMaterialReport < Report

  attr_accessor :supply_request_id, :creditor

  def materials
    supply_request = SupplyRequest.find(supply_request_id)
    Material.material_of_supply_request([supply_request.licitation_process_id, supply_request.contract_id, supply_request.creditor.id]).order(:description)
  end

end
module Report::ExtractConsumptionPerProcessHelper

  def self.get_contracts(licitation_process, contract)
    contracts = licitation_process.contracts
    contracts = contracts.where(id: contract) if contract.present?
    contracts.uniq
  end

  def self.get_purchase_solicitation(contract, purchase_solicitation)
    PurchaseSolicitation.where(id: contract&.licitation_process&.purchase_solicitations&.pluck(:purchase_solicitation_id))
  end

end
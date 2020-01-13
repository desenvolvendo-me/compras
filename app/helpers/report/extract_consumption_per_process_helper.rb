module Report::ExtractConsumptionPerProcessHelper

  def self.get_contracts(licitation_process, contract)
    contracts = licitation_process.contracts.joins(:supply_orders)
    contracts = contracts.where(id: contract) if contract.present?
    contracts.uniq
  end

end
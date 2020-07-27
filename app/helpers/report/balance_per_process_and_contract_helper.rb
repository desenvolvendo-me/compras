module Report::BalancePerProcessAndContractHelper

  def self.get_contracts(licitation_process, contract, creditor_id)
    contracts = licitation_process.contracts
    contracts = contracts.where(id: contract) if contract.present?
    contracts = contracts.joins{ creditor }.where{creditor.id.eq(creditor_id) } if creditor_id.present?
    contracts
  end

end
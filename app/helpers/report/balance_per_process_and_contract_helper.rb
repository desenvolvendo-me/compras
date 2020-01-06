module Report::BalancePerProcessAndContractHelper

  def self.get_contracts(licitation_process, contract, creditor)
    contracts = licitation_process.contracts
    contracts = contracts.where(id: contract) if contract.present?
    contracts = contracts.joins(:creditors).where("compras_contracts_unico_creditors.creditor_id = #{creditor}") if creditor.present?
    contracts
  end

end
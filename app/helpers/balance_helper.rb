module BalanceHelper
  def self.get_balance(contract, item)
    supple_order = SupplyOrder.where(contract_id: contract.id).first
    if supple_order
      balance = SupplyOrder.total_balance(contract.licitation_process, supple_order.purchase_solicitation, item.material, item.quantity, supple_order, contract)
    else
      balance = {"total" => 0, "balance" => item.quantity}
    end
    balance
  end

  def self.get_contracts(licitation_process, contract, creditor)
    contracts = licitation_process.contracts
    contracts = contracts.where(id: contract) if contract.present?
    contracts = contracts.joins(:creditors).where("compras_contracts_unico_creditors.creditor_id = #{creditor}") if creditor.present?
    contracts
  end
end
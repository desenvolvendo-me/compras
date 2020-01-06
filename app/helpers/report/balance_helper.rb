module Report::BalanceHelper

  def self.get_balance(contract, item)
    supple_order = SupplyOrder.where(contract_id: contract.id).first
    if supple_order
      balance = SupplyOrder.total_balance(contract.licitation_process, supple_order.purchase_solicitation, item.material, item.quantity, supple_order, contract)
    else
      balance = {"total" => 0, "balance" => item.quantity}
    end
    balance
  end

end
module Report::ExtractConsumptionPerProcessHelper

  def self.get_contracts(licitation_process, contract)
    contracts = licitation_process.contracts.joins(:supply_orders)
    contracts = contracts.where(id: contract) if contract.present?
    contracts.uniq
  end

  def self.get_purchase_solicitation(contract, purchase_solicitation)
    supply_orders = contract.supply_orders
    supply_orders = supply_orders.where{ purchase_solicitation_id.eq(purchase_solicitation) } if purchase_solicitation.present?

    purchase_solicitation_ids = supply_orders.pluck(:purchase_solicitation_id).uniq if supply_orders.present?

    PurchaseSolicitation.where{ id.in(purchase_solicitation_ids) }
  end

end
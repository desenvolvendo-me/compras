class ContractPerResourceSourceReport < Report
  attr_accessor :contract_id, :contract, :resource_source_id, :resource_source

  def contracts
    if contract_id.present?
      Contract.where(id: contract_id)
    else
      Contract.all
    end
  end

  def resource_sources param
    if contract_id.present?
      ResourceSource.by_contract(contract_id)
          .by_id(resource_source_id).uniq(:id)
    else
      if resource_source_id.present?
        ResourceSource.by_id(resource_source_id)
      else
        ResourceSource.joins{ expenses.contract_financials }.where{ expenses.contract_financials.contract_id.eq(param) }.uniq(:id)
      end
    end
  end
end
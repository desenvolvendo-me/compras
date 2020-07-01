class ContractPerResourceSourceReport < Report

  attr_accessor :contract_id, :contract, :resource_source_id, :resource_source

  validates :contract_id, presence: true
end
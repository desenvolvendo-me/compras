class SupplyRequestPerSecretaryReport < Report

  attr_accessor :secretary, :secretary_id, :material, :material_id, :contract, :contract_id

  validates :secretary_id, :presence => true
end
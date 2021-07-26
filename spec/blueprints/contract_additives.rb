ContractAdditive.blueprint(:aditivo) do
  number { "666" }
  additive_type { ContractAdditiveType::OTHERS }
  signature_date { Date.new(2013, 10, 13) }
  publication_date { Date.new(2013, 10, 13) }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  observation { "aditivo 1" }
  contract { Contract.make!(:primeiro_contrato) }
end

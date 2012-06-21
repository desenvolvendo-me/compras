ContractTermination.blueprint(:contrato_rescindido) do
  contract { Contract.make!(:primeiro_contrato) }
  year     { 2012 }
  number   { 1 }
  reason   { "Foo Bar" }
  expiry_date      { Date.current }
  termination_date { Date.current }
  publication_date { Date.current }
  dissemination_source { DisseminationSource.make!(:jornal_bairro) }
  fine_value { 15000.0 }
  compensation_value { 3000.0 }
end

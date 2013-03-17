Identity.blueprint(:sobrinho) do
  individual { Individual.make!(:sobrinho) }
  number { 'MG16236013' }
  issuer { Issuer::SSP }
  state  { ::FactoryGirl::Preload.factories['State'][:mg] }
  issue  { '2006-02-14' }
end

Identity.blueprint(:wenderson) do
  individual { Individual.make!(:wenderson) }
  number { 'MG23912702' }
  issuer { Issuer::SSP }
  state  { ::FactoryGirl::Preload.factories['State'][:mg] }
  issue  { '2004-07-03' }
end

Identity.blueprint(:joao_da_silva) do
  individual { Individual.make!(:joao_da_silva) }
  number { 'MG12345677' }
  issuer { Issuer::SSP }
  state  { ::FactoryGirl::Preload.factories['State'][:mg] }
  issue  { '2004-07-03' }
end
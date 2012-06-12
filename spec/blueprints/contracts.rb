# encoding: utf-8
Contract.blueprint(:primeiro_contrato) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "001" }
  process_number { "002" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2012, 2, 24) }
  description { "Objeto" }
  kind { ContractKind::MANAGEMENT }
end

Contract.blueprint(:segundo_contrato) do
  year { 2013 }
  entity { Entity.make!(:detran) }
  contract_number { "002" }
  process_number { "003" }
  signature_date { Date.new(2013, 2, 23) }
  end_date { Date.new(2013, 2, 24) }
  description { "Objeto" }
  kind { ContractKind::MANAGEMENT }
end

Contract.blueprint(:contrato_detran) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "101" }
  process_number { "10" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2013, 2, 23) }
  description { "Contrato" }
  kind { ContractKind::FOUNDED }
end

Contract.blueprint(:contrato_educacao) do
  year { 2011 }
  entity { Entity.make!(:secretaria_de_educacao) }
  contract_number { "200" }
  process_number { "20" }
  signature_date { Date.new(2012, 2, 24) }
  end_date { Date.new(2013, 2, 24) }
  description { "Contrato com a Secretaria de Educação" }
  kind { ContractKind::FOUNDED }
end

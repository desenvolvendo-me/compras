# encoding: utf-8
FoundedDebtContract.blueprint(:contrato_detran) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "101" }
  process_number { "10" }
  signed_date { "23/02/2012" }
  end_date { "23/02/2013" }
  description { "Contrato" }
end

FoundedDebtContract.blueprint(:contrato_educacao) do
  year { 2011 }
  entity { Entity.make!(:secretaria_de_educacao) }
  contract_number { "200" }
  process_number { "20" }
  signed_date { "24/02/2012" }
  end_date { "24/02/2013" }
  description { "Contrato com a Secretaria de Educação" }
end

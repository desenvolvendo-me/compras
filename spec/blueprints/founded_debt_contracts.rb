# encoding: utf-8
FoundedDebtContract.blueprint(:contrato_detran) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "101" }
  process_number { "10" }
  signed_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2013, 2, 23) }
  description { "Contrato" }
end

FoundedDebtContract.blueprint(:contrato_educacao) do
  year { 2011 }
  entity { Entity.make!(:secretaria_de_educacao) }
  contract_number { "200" }
  process_number { "20" }
  signed_date { Date.new(2012, 2, 24) }
  end_date { Date.new(2013, 2, 24) }
  description { "Contrato com a Secretaria de Educação" }
end

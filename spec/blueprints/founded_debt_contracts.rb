FoundedDebtContract.blueprint(:contrato_detran) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "101" }
  process_number { "10" }
  signed_date { "23/02/2012" }
  end_date { "23/02/2013" }
  description { "Contrato" }
end

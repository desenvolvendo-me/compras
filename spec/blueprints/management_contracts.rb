ManagementContract.blueprint(:primeiro_contrato) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "001" }
  process_number { "002" }
  signature_date { "23/02/2012" }
  end_date { "24/02/2012" }
  description { "Objeto" }
end

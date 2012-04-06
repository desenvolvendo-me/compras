ManagementContract.blueprint(:primeiro_contrato) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  contract_number { "001" }
  process_number { "002" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2012, 2, 24) }
  description { "Objeto" }
end

ManagementContract.blueprint(:segundo_contrato) do
  year { 2013 }
  entity { Entity.make!(:detran) }
  contract_number { "002" }
  process_number { "003" }
  signature_date { Date.new(2013, 2, 23) }
  end_date { Date.new(2013, 2, 24) }
  description { "Objeto" }
end

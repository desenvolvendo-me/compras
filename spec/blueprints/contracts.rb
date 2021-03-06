Contract.blueprint(:primeiro_contrato) do
  sequential_number { 1 }
  year { Date.today.year }
  contract_number { "001" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2012, 2, 24) }
  description { "Objeto" }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  contract_type { ContractType.make!(:management) }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  creditor { [Creditor.make!(:sobrinho)] }
  contract_value { 1000 }
  contract_validity { 12 }
  subcontracting { true }
  budget_structure_id { 1 }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  start_date { Date.new(2012, 1, 9) }
  content { 'Objeto' }
  penalty_fine { 'Multa rescisória' }
  default_fine { 'Multa inadimplemento' }
end

Contract.blueprint(:contrato_detran) do
  sequential_number { 3 }
  year { Date.today.year }
  contract_number { "101" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2013, 2, 23) }
  description { "Contrato" }
  contract_type { ContractType.make!(:founded) }
  creditor { Creditor.make!(:sobrinho) }
  contract_value { 1000 }
  contract_validity { 12 }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  subcontracting { true }
  budget_structure_id { 1 }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  start_date { Date.new(2012, 1, 9) }
  content { 'Objeto' }
  penalty_fine { 'Multa rescisória' }
  default_fine { 'Multa inadimplemento' }
end

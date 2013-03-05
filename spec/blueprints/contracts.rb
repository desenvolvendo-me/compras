# encoding: utf-8
Contract.blueprint(:primeiro_contrato) do
  sequential_number { 1 }
  year { 2012 }
  contract_number { "001" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2012, 2, 24) }
  description { "Objeto" }
  kind { ContractKind::MAIN }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  contract_type { ContractType.make!(:management) }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  creditor { Creditor.make!(:sobrinho) }
  contract_value { 1000 }
  contract_validity { 12 }
  contract_guarantees { ContractGuarantees::BANK }
  subcontracting { true }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  content { 'Objeto' }
end

Contract.blueprint(:segundo_contrato) do
  sequential_number { 2 }
  year { 2013 }
  contract_number { "002" }
  signature_date { Date.new(2013, 2, 23) }
  end_date { Date.new(2013, 2, 24) }
  description { "Objeto" }
  kind { ContractKind::AMENDMENT }
  parent { Contract.make!(:primeiro_contrato) }
  direct_purchase { DirectPurchase.make!(:compra) }
  contract_type { ContractType.make!(:management) }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  creditor { Creditor.make!(:sobrinho) }
  contract_value { 1000 }
  contract_validity { 12 }
  contract_guarantees { ContractGuarantees::BANK }
  subcontracting { false }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  content { 'Objeto' }
end

Contract.blueprint(:contrato_detran) do
  sequential_number { 3 }
  year { 2012 }
  contract_number { "101" }
  signature_date { Date.new(2012, 2, 23) }
  end_date { Date.new(2013, 2, 23) }
  description { "Contrato" }
  kind { ContractKind::MAIN }
  direct_purchase { DirectPurchase.make!(:compra) }
  contract_type { ContractType.make!(:founded) }
  creditor { Creditor.make!(:sobrinho) }
  contract_value { 1000 }
  contract_validity { 12 }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  contract_guarantees { ContractGuarantees::BANK }
  subcontracting { true }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  content { 'Objeto' }
end

Contract.blueprint(:contrato_educacao) do
  sequential_number { 4 }
  year { 2011 }
  contract_number { "200" }
  signature_date { Date.new(2012, 2, 24) }
  end_date { Date.new(2013, 2, 24) }
  description { "Contrato com a Secretaria de Educação" }
  kind { ContractKind::MAIN }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  creditor { Creditor.make!(:sobrinho) }
  contract_value { 1000 }
  contract_validity { 12 }
  dissemination_source { DisseminationSource.make!(:jornal_municipal) }
  contract_guarantees { ContractGuarantees::BANK }
  subcontracting { true }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  budget_structure_responsible { Employee.make!(:wenderson) }
  lawyer { Employee.make!(:wenderson) }
  lawyer_code { '5678' }
  publication_date { Date.new(2012, 1, 10) }
  content { 'Objeto' }
end

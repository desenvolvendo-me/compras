Material.blueprint(:manga) do
  materials_class { MaterialsClass.make!(:hortifrutigranjeiros) }
  code { "01.01.00001" }
  description { "Manga" }
  detailed_description { "Fruta manga" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:quilos) }
  manufacturer { "Plantador" }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  stn_ordinance { "portaria" }
  economic_classification_of_expenditure { EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios) }
end

Material.blueprint(:cadeira) do
  materials_class { MaterialsClass.make!(:pecas) }
  code { "02.02.00001" }
  description { "Cadeira" }
  detailed_description { "Cadeira de escritorio" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Moveis" }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  stn_ordinance { "portaria" }
  economic_classification_of_expenditure { EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios) }
end

Material.blueprint(:balde) do
  materials_class { MaterialsClass.make!(:pecas) }
  code { "02.02.00002" }
  description { "Balde" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  stn_ordinance { "portaria" }
  economic_classification_of_expenditure { EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios) }
end

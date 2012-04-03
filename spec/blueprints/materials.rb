Material.blueprint(:antivirus) do
  materials_class { MaterialsClass.make!(:software) }
  code { "01.01.00001" }
  description { "Antivirus" }
  detailed_description { "Antivirus avast" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Plantador" }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  expense_element { ExpenseElement.make!(:vencimento_e_salarios) }
end

Material.blueprint(:arame_farpado) do
  materials_class { MaterialsClass.make!(:arames) }
  code { "02.02.00001" }
  description { "Arame farpado" }
  detailed_description { "Arame farpado" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Moveis" }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  expense_element { ExpenseElement.make!(:vencimento_e_salarios) }
end

Material.blueprint(:arame_comum) do
  materials_class { MaterialsClass.make!(:arames) }
  code { "02.02.00002" }
  description { "Arame comum" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_or_contract_type { ServiceOrContractType.make!(:reparos) }
  material_type { 'consumption' }
  expense_element { ExpenseElement.make!(:vencimento_e_salarios) }
end

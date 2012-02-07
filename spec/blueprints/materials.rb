Material.blueprint(:manga) do
  materials_group { MaterialsGroup.make!(:alimenticios) }
  materials_class { MaterialsClass.make!(:hortifrutigranjeiros) }
  code { "01" }
  name { "Manga" }
  description { "Fruta manga" }
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
  expense_element { "elemento" }
end

Material.blueprint(:cadeira) do
  materials_group { MaterialsGroup.make!(:limpeza) }
  materials_class { MaterialsClass.make!(:pecas) }
  code { "02" }
  name { "Cadeira" }
  description { "Cadeira de escritorio" }
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
  expense_element { "elemento" }
end

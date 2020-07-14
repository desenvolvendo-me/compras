Material.blueprint(:antivirus) do
  material_class { ::FactoryGirl::Preload.factories['MaterialClass'][:software] }
  code { "01.01.00001" }
  description { "Antivirus" }
  detailed_description { "Antivirus avast" }
  reference_unit { ::FactoryGirl::Preload.factories['ReferenceUnit'][:unidade] }
  manufacturer { "Plantador" }
  combustible { false }
  material_type { MaterialType::CONSUMPTION }
  expense_nature_id { 1 }
  material_classification {MaterialClassification::CONSUMPTION}
end

Material.blueprint(:office) do
  material_class { ::FactoryGirl::Preload.factories['MaterialClass'][:software] }
  code { "01.01.00002" }
  description { "Office" }
  detailed_description { "MS Office" }
  reference_unit { ::FactoryGirl::Preload.factories['ReferenceUnit'][:unidade] }
  manufacturer { "MS" }
  combustible { false }
  material_type { MaterialType::CONSUMPTION }
  expense_nature_id { 1 }
  material_classification {MaterialClassification::CONSUMPTION}
end

Material.blueprint(:arame_farpado) do
  material_class { ::FactoryGirl::Preload.factories['MaterialClass'][:arames] }
  code { "02.02.00001" }
  description { "Arame farpado" }
  detailed_description { "Arame farpado" }
  reference_unit { ::FactoryGirl::Preload.factories['ReferenceUnit'][:unidade] }
  manufacturer { "Moveis" }
  combustible { false }
  material_type { MaterialType::CONSUMPTION }
  expense_nature_id { 1 }
  material_classification {MaterialClassification::CONSUMPTION}
end

Material.blueprint(:arame_comum) do
  material_class { ::FactoryGirl::Preload.factories['MaterialClass'][:arames] }
  code { "02.02.00002" }
  description { "Arame comum" }
  detailed_description { "Arame comum" }
  reference_unit { ::FactoryGirl::Preload.factories['ReferenceUnit'][:unidade] }
  combustible { false }
  material_type { MaterialType::CONSUMPTION }
  expense_nature_id { 1 }
  material_classification {MaterialClassification::CONSUMPTION}
end

Material.blueprint(:manutencao) do
  material_class { ::FactoryGirl::Preload.factories['MaterialClass'][:software] }
  code { "01.05.00001" }
  description { "Manutenção de Computadores" }
  detailed_description { "Manutenção de Computadores" }
  reference_unit { ::FactoryGirl::Preload.factories['ReferenceUnit'][:unidade] }
  material_type { MaterialType::SERVICE }
  expense_nature_id { 1 }
  material_classification {MaterialClassification::CONSUMPTION}
end

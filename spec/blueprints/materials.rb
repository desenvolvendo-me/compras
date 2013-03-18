#encoding: utf-8
Material.blueprint(:antivirus) do
  materials_class { MaterialsClass.make!(:software) }
  code { "01.01.00001" }
  description { "Antivirus" }
  detailed_description { "Antivirus avast" }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Plantador" }
  combustible { false }
  contract_type { ContractType.make!(:reparos) }
  material_type { MaterialType::CONSUMPTION }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Material.blueprint(:office) do
  materials_class { MaterialsClass.make!(:software) }
  code { "01.01.00002" }
  description { "Office" }
  detailed_description { "MS Office" }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "MS" }
  combustible { false }
  contract_type { ContractType.make!(:reparos) }
  material_type { MaterialType::CONSUMPTION }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Material.blueprint(:arame_farpado) do
  materials_class { MaterialsClass.make!(:arames) }
  code { "02.02.00001" }
  description { "Arame farpado" }
  detailed_description { "Arame farpado" }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Moveis" }
  combustible { false }
  contract_type { ContractType.make!(:reparos) }
  material_type { MaterialType::CONSUMPTION }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Material.blueprint(:arame_comum) do
  materials_class { MaterialsClass.make!(:arames) }
  code { "02.02.00002" }
  description { "Arame comum" }
  detailed_description { "Arame comum" }
  reference_unit { ReferenceUnit.make!(:unidade) }
  combustible { false }
  contract_type { ContractType.make!(:reparos) }
  material_type { MaterialType::CONSUMPTION }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Material.blueprint(:manutencao) do
  materials_class { MaterialsClass.make!(:software) }
  code { "01.05.00001" }
  description { "Manutenção de Computadores" }
  detailed_description { "Manutenção de Computadores" }
  reference_unit { ReferenceUnit.make!(:unidade) }
  contract_type { ContractType.make!(:reparos) }
  material_type { MaterialType::SERVICE }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

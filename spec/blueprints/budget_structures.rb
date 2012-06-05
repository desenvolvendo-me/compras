# encoding: utf-8
BudgetStructure.blueprint(:secretaria_de_educacao) do
  budget_structure_configuration { BudgetStructureConfiguration.make!(:detran_sopa) }
  budget_structure { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Educação' }
  kind { BudgetStructureKind::ANALYTICAL }
  acronym { 'SEMUEDU' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_structure_responsibles { [BudgetStructureResponsible.make!(:sobrinho)] }
end

BudgetStructure.blueprint(:secretaria_de_desenvolvimento) do
  budget_structure_configuration { BudgetStructureConfiguration.make!(:detran_sopa) }
  budget_structure { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Desenvolvimento' }
  kind { BudgetStructureKind::ANALYTICAL }
  acronym { 'SEMUDES' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_structure_responsibles { [BudgetStructureResponsible.make!(:sobrinho)] }
end

# encoding: utf-8
BudgetStructure.blueprint(:secretaria_de_educacao) do
  budget_structure_configuration { BudgetStructureConfiguration.make!(:detran_sopa) }
  code { '1' }
  tce_code { '051' }
  description { 'Secretaria de Educação' }
  kind { BudgetStructureKind::SYNTHETIC }
  acronym { 'SEMUEDU' }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_structure_responsibles { [BudgetStructureResponsible.make!(:sobrinho)] }
  budget_structure_level { BudgetStructureLevel.make!(:orgao) }
end

BudgetStructure.blueprint(:secretaria_de_desenvolvimento) do
  budget_structure_configuration { BudgetStructureConfiguration.make!(:detran_sopa) }
  code { '29' }
  tce_code { '051' }
  description { 'Secretaria de Desenvolvimento' }
  kind { BudgetStructureKind::SYNTHETIC }
  acronym { 'SEMUDES' }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_structure_responsibles { [BudgetStructureResponsible.make!(:sobrinho)] }
  budget_structure_level { BudgetStructureLevel.make!(:unidade) }
  parent { BudgetStructure.make!(:secretaria_de_educacao) }
end

BudgetStructure.blueprint(:secretaria_de_educacao_com_dois_responsaveis) do
  budget_structure_configuration { BudgetStructureConfiguration.make!(:detran_sopa) }
  code { '1' }
  tce_code { '051' }
  description { 'Secretaria de Educação com dois responsaveis' }
  kind { BudgetStructureKind::SYNTHETIC }
  acronym { 'SEMUEDU' }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_structure_responsibles { [
    BudgetStructureResponsible.make!(:sobrinho_inativo),
    BudgetStructureResponsible.make!(:wenderson)
  ] }
  budget_structure_level { BudgetStructureLevel.make!(:orgao) }
end

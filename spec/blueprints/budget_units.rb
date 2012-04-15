# encoding: utf-8
BudgetUnit.blueprint(:secretaria_de_educacao) do
  budget_unit_configuration { BudgetUnitConfiguration.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Educação' }
  kind { BudgetUnitKind::ANALYTICAL }
  acronym { 'SEMUEDU' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_unit_responsibles { [BudgetUnitResponsible.make!(:sobrinho)] }
end

BudgetUnit.blueprint(:secretaria_de_desenvolvimento) do
  budget_unit_configuration { BudgetUnitConfiguration.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Desenvolvimento' }
  kind { BudgetUnitKind::ANALYTICAL }
  acronym { 'SEMUDES' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  budget_unit_responsibles { [BudgetUnitResponsible.make!(:sobrinho)] }
end

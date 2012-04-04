# encoding: utf-8
BudgetUnit.blueprint(:secretaria_de_educacao) do
  organogram_configuration { OrganogramConfiguration.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Educação' }
  organogram_kind { BudgetUnitKind::ANALYTICAL }
  acronym { 'SEMUEDU' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  organogram_responsibles { [OrganogramResponsible.make!(:sobrinho)] }
end

BudgetUnit.blueprint(:secretaria_de_desenvolvimento) do
  organogram_configuration { OrganogramConfiguration.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  description { 'Secretaria de Desenvolvimento' }
  organogram_kind { BudgetUnitKind::ANALYTICAL }
  acronym { 'SEMUDES' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  organogram_responsibles { [OrganogramResponsible.make!(:sobrinho)] }
end

# encoding: utf-8
Organogram.blueprint(:secretaria_de_educacao) do
  configuration_organogram { ConfigurationOrganogram.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  name { 'Secretaria de Educação' }
  organogram_kind { OrganogramKind::ANALYTICAL }
  acronym { 'SEMUEDU' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  organogram_responsibles { [OrganogramResponsible.make!(:sobrinho)] }
end

Organogram.blueprint(:secretaria_de_desenvolvimento) do
  configuration_organogram { ConfigurationOrganogram.make!(:detran_sopa) }
  organogram { '02.00' }
  tce_code { '051' }
  name { 'Secretaria de Desenvolvimento' }
  organogram_kind { OrganogramKind::ANALYTICAL }
  acronym { 'SEMUDES' }
  administration_type { AdministrationType.make!(:publica) }
  performance_field { 'Desenvolvimento Educacional' }
  address { Address.make!(:general) }
  organogram_responsibles { [OrganogramResponsible.make!(:sobrinho)] }
end

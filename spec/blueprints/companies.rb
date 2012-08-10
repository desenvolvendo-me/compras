# encoding: utf-8

Company.blueprint(:nohup) do
  cnpj { "00.000.000/9999-62" }
  legal_nature { LegalNature.make!(:administracao_publica) }
  responsible { Person.make!(:wenderson) }
  state_registration { "SP" }
  commercial_registration_number { "099901" }
  commercial_registration_date { Date.new(2011, 6, 29) }
  company_size { CompanySize.make!(:micro_empresa) }
  choose_simple { false }
  responsible_role { "Administrador" }
  partners { [Partner.make!(:wenderson)] }
end

Company.blueprint(:nobe) do
  cnpj { "76.238.594/0001-35" }
  legal_nature { LegalNature.make!(:administracao_publica) }
  responsible { Person.make!(:wenderson) }
  state_registration { "SP" }
  commercial_registration_number { "099901" }
  commercial_registration_date { Date.new(2011, 6, 29) }
  company_size { CompanySize.make!(:micro_empresa) }
  choose_simple { false }
  responsible_role { "Administrador" }
  partners { [Partner.make!(:wenderson)] }
end

Company.blueprint(:ibrama) do
  cnpj { "85.113.468/0001-45" }
  legal_nature { LegalNature.make!(:administracao_publica) }
  responsible { Person.make!(:wenderson) }
  state_registration { "SP" }
  commercial_registration_number { "099901" }
  commercial_registration_date { "2011-06-29" }
  company_size { CompanySize.make!(:micro_empresa) }
  choose_simple { true }
  responsible_role { "Administrador" }
  partners { [Partner.make!(:wenderson)] }
end

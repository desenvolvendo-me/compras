Provider.blueprint(:wenderson_sa) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:wenderson) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { Date.new(2012, 2, 15) }
  bank_account { '123456' }
  crc_number { '456789' }
  crc_registration_date { Date.new(2012, 2, 26) }
  crc_renewal_date { Date.new(2012, 2, 27) }
  crc_expiration_date { Date.new(2012, 2, 28) }
  provider_partners { [ProviderPartner.make!(:sobrinho)] }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
end

Provider.blueprint(:sobrinho_sa) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:sobrinho) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { Date.new(2012, 2, 15) }
  bank_account { '123456' }
  crc_number { '123456' }
  crc_registration_date { Date.new(2012, 2, 26) }
  crc_renewal_date { Date.new(2012, 2, 27) }
  crc_expiration_date { Date.new(2012, 2, 28) }
  materials_groups { [MaterialsGroup.make!(:ferro_aco)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
  provider_partners { [ProviderPartner.make!(:sobrinho)] }
end

Provider.blueprint(:fornecedor_class_arames) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:sobrinho) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { Date.new(2012, 2, 15) }
  bank_account { '123456' }
  crc_number { '222222' }
  crc_registration_date { Date.new(2012, 2, 26) }
  crc_renewal_date { Date.new(2012, 2, 27) }
  crc_expiration_date { Date.new(2012, 2, 28) }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:arames)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
  provider_partners { [ProviderPartner.make!(:sobrinho)] }
end

Provider.blueprint(:fornecedor_arame) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:sobrinho) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { Date.new(2012, 2, 15) }
  bank_account { '123456' }
  crc_number { '333333' }
  crc_registration_date { Date.new(2012, 2, 26) }
  crc_renewal_date { Date.new(2012, 2, 27) }
  crc_expiration_date { Date.new(2012, 2, 28) }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:arame_comum)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
  provider_partners { [ProviderPartner.make!(:sobrinho)] }
end

Provider.blueprint(:fornecedor_empresa) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:nohup) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { Date.new(2012, 2, 15) }
  bank_account { '123456' }
  crc_number { '456789' }
  crc_registration_date { Date.new(2012, 2, 26) }
  crc_renewal_date { Date.new(2012, 2, 27) }
  crc_expiration_date { Date.new(2012, 2, 28) }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
  provider_partners { [ProviderPartner.make!(:sobrinho)] }
end

Provider.blueprint(:wenderson_sa) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:wenderson) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { '15/02/2012' }
  bank_account { '123456' }
  crc_number { '456789' }
  crc_registration_date { '26/02/2012' }
  crc_renewal_date { '27/02/2012' }
  crc_expiration_date { '28/02/2012' }
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
  registration_date { '15/02/2012' }
  bank_account { '123456' }
  crc_number { '123456' }
  crc_registration_date { '26/02/2012' }
  crc_renewal_date { '27/02/2012' }
  crc_expiration_date { '28/02/2012' }
  materials_groups { [MaterialsGroup.make!(:ferro_aco)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
end

Provider.blueprint(:fornecedor_class_arames) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:sobrinho) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { '15/02/2012' }
  bank_account { '123456' }
  crc_number { '222222' }
  crc_registration_date { '26/02/2012' }
  crc_renewal_date { '27/02/2012' }
  crc_expiration_date { '28/02/2012' }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:arames)] }
  materials { [Material.make!(:antivirus)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
end

Provider.blueprint(:fornecedor_arame) do
  economic_registration { EconomicRegistration.make!(:nohup) }
  person { Person.make!(:sobrinho) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { '15/02/2012' }
  bank_account { '123456' }
  crc_number { '333333' }
  crc_registration_date { '26/02/2012' }
  crc_renewal_date { '27/02/2012' }
  crc_expiration_date { '28/02/2012' }
  materials_groups { [MaterialsGroup.make!(:informatica)] }
  materials_classes { [MaterialsClass.make!(:software)] }
  materials { [Material.make!(:arame_comum)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
end

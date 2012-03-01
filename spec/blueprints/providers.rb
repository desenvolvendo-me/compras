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
  materials_groups { [MaterialsGroup.make!(:alimenticios)] }
  materials_classes { [MaterialsClass.make!(:hortifrutigranjeiros)] }
  materials { [Material.make!(:cadeira)] }
  provider_licitation_documents { [ProviderLicitationDocument.make(:oficial)] }
end

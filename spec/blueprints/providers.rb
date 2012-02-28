Provider.blueprint(:wenderson_sa) do
  person { Person.make!(:wenderson) }
  property { Property.make!(:propriedade_1) }
  agency { Agency.make!(:itau) }
  legal_nature { LegalNature.make!(:administracao_publica) }
  cnae { Cnae.make!(:aluguel) }
  registration_date { '15/02/2012' }
  bank_account { '123456' }
  crc_number { '456789' }
  crc_registration_date { '26/02/2012' }
  crc_renewal_date { '27/02/2012' }
  crc_expiration_date { '28/02/2012' }
end

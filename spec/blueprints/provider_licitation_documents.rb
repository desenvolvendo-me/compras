ProviderLicitationDocument.blueprint(:oficial) do
  document_type { DocumentType.make!(:fiscal) }
  document_number { '123456' }
  emission_date { '22/02/2012' }
  expiration_date { '22/03/2012' }
end

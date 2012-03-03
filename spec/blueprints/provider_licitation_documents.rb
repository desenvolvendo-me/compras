ProviderLicitationDocument.blueprint(:oficial) do
  document_type { DocumentType.make!(:fiscal) }
  document_number { '123456' }
  emission_date { I18n.l(Date.today) }
  expiration_date { I18n.l(Date.today + 5.days) }
end

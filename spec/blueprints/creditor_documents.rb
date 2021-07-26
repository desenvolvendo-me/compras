CreditorDocument.blueprint(:documento) do
  document_type { DocumentType.make!(:fiscal) }
  document_number { '123456' }
  emission_date { I18n.l(Date.current) }
  validity { I18n.l(Date.tomorrow) }
  issuer { Issuer::SSP }
end

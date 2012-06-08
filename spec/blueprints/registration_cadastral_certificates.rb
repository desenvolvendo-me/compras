# encoding: utf-8

RegistrationCadastralCertificate.blueprint(:crc) do
  fiscal_year { 2012 }
  specification { "Especificação do certificado do registro cadastral" }
  registration_date { Date.yesterday }
  validity_date { Date.current }
  revocation_date { Date.tomorrow }
  capital_stock { "12349.99" }
  capital_whole { "56789.99" }
  total_sales { "123456789.99" }
  building_area { "99.99" }
  total_area { "123.99" }
  total_employees { 1 }
  commercial_registry_registration_date { Date.current }
  commercial_registry_number { "12345678-x" }
end

Agency.blueprint(:itau) do
  digit { '5' }
  email { 'agency_email@santander.com.br' }
  fax { '(11) 9090-7070' }
  name { 'Agência Santander' }
  number { '10099' }
  phone { '(11) 7070-7070' }
  bank { Bank.make!(:itau) }
end

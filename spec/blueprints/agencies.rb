# encoding: utf-8
Agency.blueprint(:itau) do
  name { "Agência Itaú" }
  number { "10009" }
  digit { "1" }
  bank { Bank.make!(:itau) }
  phone { "(11) 7070-7070" }
  fax { "(11) 9090-7070" }
  email { "agency_email@itau.com.br" }
end

Agency.blueprint(:santander) do
  name { "Agência Santander" }
  number { "10099" }
  digit { "5" }
  bank { Bank.make!(:santander) }
  phone { "(11) 7070-7070" }
  fax { "(11) 9090-7070" }
  email { "agency_email@santander.com.br" }
end

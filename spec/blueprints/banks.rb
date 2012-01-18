# encoding: utf-8
Bank.blueprint(:itau) do
  name { "Itaú" }
  code { 341 }
  acronym { "IT" }
end

Bank.blueprint(:santander) do
  name { "Santander" }
  code { 33 }
  acronym { "ST" }
end

Bank.blueprint(:banco_do_brasil) do
  name { "Banco do Brasil" }
  code { 1 }
  acronym { "BB" }
end
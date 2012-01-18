# encoding: utf-8
BankAccount.blueprint(:itau_tributos) do
  name { "Itaú Tributos" }
  agency { Agency.make!(:itau) }
  account_number { "1111-2" }
  originator { "0000000001" }
  number_agreement { "0001-2011" }
end

BankAccount.blueprint(:santander_folha) do
  name { "Santander - Folha de Pagamento" }
  agency { Agency.make!(:santander) }
  account_number { "2222-1" }
  originator { "0000000002" }
  number_agreement { "0001-2011" }
end

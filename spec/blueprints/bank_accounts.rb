# encoding: utf-8
BankAccount.blueprint(:itau_tributos) do
  description { "Itaú Tributos" }
  agency { Agency.make!(:itau) }
  account_number { "1111" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 2 }
end

BankAccount.blueprint(:santander_folha) do
  description { "Santander - Folha de Pagamento" }
  agency { Agency.make!(:santander) }
  account_number { "2222" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 1 }
end

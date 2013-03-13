# encoding: utf-8
BankAccount.blueprint(:itau_tributos) do
  description { "Itaú Tributos" }
  agency { Agency.make!(:itau) }
  account_number { "1111" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 2 }
  capabilities { [BankAccountCapability.make!(:reforma)] }
end
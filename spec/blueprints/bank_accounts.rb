# encoding: utf-8
BankAccount.blueprint(:itau_tributos) do
  description { "Itaú Tributos" }
  agency { ::FactoryGirl::Preload.factories['Agency'][:itau] }
  account_number { "1111" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 2 }
  capabilities { [BankAccountCapability.make!(:reforma)] }
end

# encoding: utf-8
BankAccount.blueprint(:santander_tributos) do
  description { "Santander Tributos" }
  agency { ::FactoryGirl::Preload.factories['Agency'][:santander] }
  account_number { "1111" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 2 }
  capabilities { [BankAccountCapability.make!(:reforma)] }
end

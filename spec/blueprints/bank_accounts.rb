BankAccount.blueprint(:itau_tributos) do
  description { "Itaú Tributos" }
  agency { ::FactoryGirl::Preload.factories['Agency'][:itau] }
  account_number { "1111" }
  status { Status::ACTIVE }
  kind { BankAccountKind::APPLICATION }
  digit { 2 }
end

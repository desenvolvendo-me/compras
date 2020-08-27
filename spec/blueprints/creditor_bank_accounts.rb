CreditorBankAccount.blueprint(:conta) do
  agency { Agency.make!(:itau) }
  status { Status::ACTIVE }
  account_type { AccountType::CHECKING_ACCOUNT }
  number { 1234 }
  digit { 0 }
end

CreditorBankAccount.blueprint(:conta_2) do
  agency { Agency.make!(:itau) }
  status { Status::ACTIVE }
  account_type { AccountType::CHECKING_ACCOUNT }
  number { 3456 }
  digit { 0 }
end

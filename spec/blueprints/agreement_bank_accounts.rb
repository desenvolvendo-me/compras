AgreementBankAccount.blueprint(:itau) do
  bank_account { BankAccount.make!(:itau_tributos) }
  creation_date { Date.current }
  status { Status::ACTIVE }
end

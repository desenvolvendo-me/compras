AgreementBankAccount.blueprint(:itau) do
  bank_account { BankAccount.make!(:itau_tributos) }
  creation_date { Date.yesterday }
  desactivation_date { Date.current }
  status { Status::INACTIVE }
end

AgreementBankAccount.blueprint(:santander) do
  bank_account { BankAccount.make!(:santander_folha) }
  creation_date { Date.current }
  status { Status::ACTIVE }
end

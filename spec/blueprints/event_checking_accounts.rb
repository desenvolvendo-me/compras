# encoding: utf-8
EventCheckingAccount.blueprint(:disponibilidade_financeira) do
  checking_account_of_fiscal_account { CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira) }
  nature_release { NatureRelease::DEBT }
  operation { Operation::SUM }
end

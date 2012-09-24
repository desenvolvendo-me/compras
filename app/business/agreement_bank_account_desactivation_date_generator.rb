class AgreementBankAccountDesactivationDateGenerator
  attr_accessor :bank_accounts

  def initialize(bank_accounts)
    self.bank_accounts = bank_accounts
  end

  def change!
    bank_accounts.each do |bank_account|
      next if bank_account.desactivation_date?

      bank_account.desactivation_date = Date.current
    end
  end
end

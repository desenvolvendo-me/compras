class AgreementBankAccountStatusChanger
  attr_accessor :bank_accounts, :status

  def initialize(bank_accounts, status = Status)
    self.bank_accounts = bank_accounts
    self.status = status
  end

  def change!
    bank_accounts.each_with_index do |bank, index|
      bank.status = bank_status(bank, index)
      bank.desactivation_date = nil if bank.active?
    end
  end

  protected

  def bank_status(bank, index)
    if index.succ == bank_accounts.size
      active_status
    else
      inactive_status
    end
  end

  def inactive_status
    status.value_for(:INACTIVE)
  end

  def active_status
    status.value_for(:ACTIVE)
  end
end

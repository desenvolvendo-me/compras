class AgreementBankAccountStatusChanger
  attr_accessor :agreement, :status, :creation_date_changer,
                :desactivation_date_changer

  delegate :agreement_bank_accounts_not_marked_for_destruction,
           :to => :agreement, :allow_nil => true

  def initialize(agreement, status = Status, creation_date_changer = AgreementBankAccountCreationDateGenerator, desactivation_date_changer = AgreementBankAccountDesactivationDateGenerator)
    self.agreement = agreement
    self.status = status
    self.creation_date_changer = creation_date_changer
    self.desactivation_date_changer = desactivation_date_changer
  end

  def change!
    agreement_bank_accounts_not_marked_for_destruction.each_with_index do |bank, index|
      bank.status = bank_status(bank, index)
      bank.desactivation_date = nil if bank.active?
    end

    creation_date_changer.new(agreement_bank_accounts_not_marked_for_destruction).change!
    desactivation_date_changer.new(agreement_bank_accounts_not_marked_for_destruction).change!

    agreement.save
  end

  protected

  def bank_status(bank, index)
    if index.succ == agreement_bank_accounts_not_marked_for_destruction.size
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

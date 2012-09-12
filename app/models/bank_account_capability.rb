class BankAccountCapability < Compras::Model
  attr_accessible :date, :inactivation_date, :status, :bank_account_id, :capability_id

  has_enumeration_for :status, :create_helpers => true

  belongs_to :bank_account
  belongs_to :capability

  validates :capability, :presence => true

  def activate!(update_date)
    active!
    self.date = update_date

    save!
  end

  def inactivate!(update_date)
    inactive!
    self.date ||= update_date
    self.inactivation_date = update_date

    save!
  end
end

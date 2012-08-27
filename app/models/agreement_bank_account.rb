class AgreementBankAccount < Compras::Model
  attr_accessible :bank_account_id, :creation_date, :status,
                  :desactivation_date

  has_enumeration_for :status

  belongs_to :agreement
  belongs_to :bank_account

  validates :bank_account, :creation_date, :status, :presence => true
end

class EventCheckingAccount < Compras::Model
  attr_accessible :checking_account_of_fiscal_account_id, :nature_release,
                  :operation

  has_enumeration_for :nature_release
  has_enumeration_for :operation

  belongs_to :event_checking_configuration
  belongs_to :checking_account_of_fiscal_account

  validates :checking_account_of_fiscal_account, :nature_release,
            :operation, :presence => true
end

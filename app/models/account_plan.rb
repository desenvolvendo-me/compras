class AccountPlan < Compras::Model
  attr_accessible :account_plan_configuration_id, :checking_account, :function,
                  :title, :nature_balance, :nature_information,
                  :nature_balance_variation, :bookkeeping, :surplus_indicator,
                  :movimentation_kind, :checking_account_of_fiscal_account_id,
                  :ends_at_twelfth_month, :ends_at_thirteenth_month,
                  :ends_at_fourteenth_month, :does_not_ends,
                  :detailing_required_opening, :detailing_required_thirteenth,
                  :detailing_required_fourteenth

  has_enumeration_for :nature_balance
  has_enumeration_for :nature_information
  has_enumeration_for :nature_balance_variation
  has_enumeration_for :surplus_indicator
  has_enumeration_for :movimentation_kind

  belongs_to :account_plan_configuration
  belongs_to :checking_account_of_fiscal_account

  delegate :mask, :to => :account_plan_configuration, :allow_nil => true

  validates :account_plan_configuration, :checking_account, :function, :title,
            :nature_balance, :nature_information, :nature_balance_variation,
            :surplus_indicator, :movimentation_kind, :presence => true
  validates :checking_account, :mask => :mask

  orderize :title
  filterize

  def to_s
    title
  end
end

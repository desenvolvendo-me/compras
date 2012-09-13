class AccountPlan < Compras::Model
  attr_accessible :account_plan_configuration_id, :checking_account, :function,
                  :title

  delegate :mask, :to => :account_plan_configuration, :allow_nil => true

  belongs_to :account_plan_configuration

  validates :account_plan_configuration, :checking_account, :function, :title,
            :presence => true
  validates :checking_account, :mask => :mask

  orderize :title
  filterize

  def to_s
    title
  end
end

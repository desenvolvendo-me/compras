class AccountPlanLevel < Compras::Model
  attr_accessible :level, :description, :digits, :separator,
                  :account_plan_configuration_id

  has_enumeration_for :separator, :with => AccountPlanSeparator

  belongs_to :account_plan_configuration

  validates :description, :level, :digits, :presence => true
end

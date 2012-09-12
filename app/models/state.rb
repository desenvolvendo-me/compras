class State < Unico::State
  attr_modal :name

  has_many :account_plan_configurations, :dependent => :restrict

  filterize
  orderize
end

class State < Unico::State
  attr_modal :name

  has_many :account_plan_configurations, :dependent => :restrict

  filterize
  orderize

  def self.id_by_name!(name)
    find_by_name!(name).id
  end
end

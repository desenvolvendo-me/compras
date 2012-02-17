class BudgetAllocationType < ActiveRecord::Base
  attr_accessible :description

  has_many :budget_allocations, :dependent => :restrict

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true

  def to_s
    description
  end
end

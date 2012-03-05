class BudgetAllocationType < ActiveRecord::Base
  attr_accessible :description, :status

  has_enumeration_for :source
  has_enumeration_for :status, :create_helpers => true

  has_many :budget_allocations, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true
  validates :status, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end

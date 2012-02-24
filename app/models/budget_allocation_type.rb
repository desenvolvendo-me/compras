class BudgetAllocationType < ActiveRecord::Base
  attr_accessible :description, :status

  has_many :budget_allocations, :dependent => :restrict

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true
  validates :status, :presence => true

  has_enumeration_for :source, :create_helpers => true
  has_enumeration_for :status, :create_helpers => true

  def to_s
    description
  end
end

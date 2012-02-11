class BudgetAllocation < ActiveRecord::Base
  attr_accessible :name, :amount

  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end

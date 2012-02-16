class BudgetAllocation < ActiveRecord::Base
  attr_accessible :description, :amount

  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict

  orderize :description
  filterize

  validates :description, :presence => true
  validates :description, :uniqueness => true

  def to_s
    description
  end
end

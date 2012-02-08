class BudgetAllocation < ActiveRecord::Base
  attr_accessible :name

  has_many :purchase_solicitations

  has_many :purchase_solicitation_budget_allocations

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end

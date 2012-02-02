class BudgetAllocation < ActiveRecord::Base
  attr_accessible :name

  has_many :purchase_solicitations

  has_and_belongs_to_many :purchase_solicitations

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end

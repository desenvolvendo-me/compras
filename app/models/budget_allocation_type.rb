class BudgetAllocationType < ActiveRecord::Base
  attr_accessible :description

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true

  def to_s
    description
  end
end

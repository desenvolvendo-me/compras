class ExpenseKind < ActiveRecord::Base
  attr_accessible :description, :status

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true
  validates :status, :presence => true

  has_enumeration_for :status, :create_helpers => true, :with => ExpenseKindStatus

  def to_s
    description
  end
end

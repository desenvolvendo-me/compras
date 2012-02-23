class ReserveFund < ActiveRecord::Base
  attr_accessible :entity_id, :budget_allocation_id, :year
  attr_accessible :value

  belongs_to :entity
  belongs_to :budget_allocation

  validates :entity, :budget_allocation, :value, :presence => true
  validates :year, :presence => true, :mask => '9999'

  orderize :year
  filterize

  def to_s
    "#{id}/#{year}"
  end
end

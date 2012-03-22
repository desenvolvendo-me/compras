class LicitationProcessBudgetAllocationItem < ActiveRecord::Base
  attr_accessible :licitation_process_budget_allocation_id, :material_id
  attr_accessible :quantity, :unit_price

  belongs_to :licitation_process_budget_allocation
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true

  validates :material, :quantity, :unit_price, :presence => true

  def estimated_total_price
    if (quantity && unit_price)
      quantity * unit_price
    else
      0
    end
  end
end

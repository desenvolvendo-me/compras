class AdministrativeProcessBudgetAllocationItem < ActiveRecord::Base
  attr_accessible :administrative_process_budget_allocation_id, :material_id, :quantity, :unit_price

  attr_accessor :order

  belongs_to :administrative_process_budget_allocation
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true

  def estimated_total_price
    if quantity && unit_price
      quantity * unit_price
    else
      0
    end
  end
end

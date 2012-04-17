class PurchaseSolicitationBudgetAllocationItem < ActiveRecord::Base
  attr_accessible :purchase_solicitation_budget_allocation_id, :material_id
  attr_accessible :brand, :quantity, :unit_price

  attr_accessor :order

  belongs_to :purchase_solicitation_budget_allocation
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true

  validates :material, :quantity, :unit_price, :presence => true

  def estimated_total_price
    (quantity || 0) * (unit_price || 0)
  end
end

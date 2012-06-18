class DirectPurchaseBudgetAllocationItem < Compras::Model
  attr_accessible :direct_purchase_budget_allocation_id, :material_id
  attr_accessible :brand, :quantity, :unit_price

  attr_accessor :order

  belongs_to :direct_purchase_budget_allocation
  belongs_to :material

  delegate :reference_unit, :materials_class, :materials_group, :to => :material, :allow_nil => true
  delegate :licitation_object_id, :to => :direct_purchase_budget_allocation, :allow_nil => true

  validates :material, :quantity, :unit_price, :presence => true
  validates :unit_price, :numericality => { :greater_than => 0 }

  def estimated_total_price
    if quantity && unit_price
      quantity * unit_price
    else
      0
    end
  end

  scope :by_modality, lambda { |modality|
    joins{ direct_purchase_budget_allocation.direct_purchase }.
    where {
      direct_purchase_budget_allocation.direct_purchase.modality.eq(modality)
    }
  }
end

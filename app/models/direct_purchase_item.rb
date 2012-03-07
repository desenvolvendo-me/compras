class DirectPurchaseItem < ActiveRecord::Base
  attr_accessible :direct_purchase_id, :material_id, :brand, :quantity, :unit_price

  delegate :reference_unit, :to => :material, :allow_nil => true

  belongs_to :direct_purchase
  belongs_to :material

  def estimated_total_price
    if (quantity && unit_price)
      quantity * unit_price
    else
      0
    end
  end
end

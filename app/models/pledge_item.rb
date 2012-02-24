class PledgeItem < ActiveRecord::Base
  attr_accessible :material_id, :description, :quantity, :unit_price

  attr_readonly :description

  belongs_to :pledge
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true

  validates :material_id, :quantity, :unit_price, :presence => true

  def estimated_total_price
    if (quantity && unit_price)
      quantity * unit_price
    else
      0
    end
  end
end

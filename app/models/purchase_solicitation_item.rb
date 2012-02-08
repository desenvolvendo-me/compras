class PurchaseSolicitationItem < ActiveRecord::Base
  attr_accessible :material_id, :quantity, :unit_price, :status

  attr_protected :grouped, :material, :process_number

  belongs_to :purchase_solicitation
  belongs_to :material

  has_enumeration_for :status, :with => PurchaseSolicitationItemStatus

  validates :material_id, :quantity, :unit_price, :presence => true

  delegate :reference_unit, :to => :material, :allow_nil => true

  def estimated_total_price
    if (quantity && unit_price)
      quantity * unit_price
    else
      0
    end
  end
end

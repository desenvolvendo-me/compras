class PurchaseSolicitationItem < ActiveRecord::Base
  attr_accessible :material_id, :quantity, :unit_price, :estimated_total_price, :status

  attr_protected :grouped, :material, :process_number

  belongs_to :purchase_solicitation
  belongs_to :material

  has_enumeration_for :status, :with => PurchaseSolicitationItemStatus

  validates :material_id, :quantity, :unit_price, :estimated_total_price, :presence => true

  delegate :reference_unit, :to => :material, :allow_nil => true
end

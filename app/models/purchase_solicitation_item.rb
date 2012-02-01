class PurchaseSolicitationItem < ActiveRecord::Base
  attr_accessible :material_id, :quantity, :unit_price, :estimated_total_price, :status

  attr_protected :grouped, :material, :process_number

  attr_accessor :reference_unit

  belongs_to :purchase_solicitation
  belongs_to :material

  has_enumeration_for :status, :with => PurchaseSolicitationItemStatus

  validates :material_id, :quantity, :unit_price, :estimated_total_price, :presence => true

  before_create :set_status_to_pending

  protected

  def set_status_to_pending
    self.status = 'pending'
  end
end

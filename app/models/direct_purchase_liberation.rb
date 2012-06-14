class DirectPurchaseLiberation < Compras::Model
  attr_accessible :description, :evaluation, :direct_purchase_id, :employee_id

  has_enumeration_for :evaluation, :with => DirectPurchaseStatus

  belongs_to :direct_purchase
  belongs_to :employee

  validates :evaluation, :employee, :direct_purchase, :presence => true

  orderize
  filterize

  def to_s
    "#{id}"
  end
end

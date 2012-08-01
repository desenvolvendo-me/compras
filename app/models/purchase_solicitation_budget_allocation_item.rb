class PurchaseSolicitationBudgetAllocationItem < Compras::Model
  attr_accessible :purchase_solicitation_budget_allocation_id, :material_id
  attr_accessible :brand, :quantity, :unit_price, :status

  attr_accessor :order

  has_enumeration_for :status, :with => PurchaseSolicitationBudgetAllocationItemStatus

  belongs_to :purchase_solicitation_budget_allocation
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true
  delegate :annulled?, :to => :purchase_solicitation_budget_allocation, :allow_nil => true

  validates :material, :quantity, :unit_price, :status, :presence => true

  def estimated_total_price
    (quantity || 0) * (unit_price || 0)
  end

  def self.group!(ids)
    where { id.in(ids) }.update_all(
      :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED
    )
  end

  def self.pending!(ids)
    where { id.in(ids) }.update_all(
      :status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING
    )
  end
end

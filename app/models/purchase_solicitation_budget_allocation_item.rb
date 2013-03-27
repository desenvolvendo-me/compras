class PurchaseSolicitationBudgetAllocationItem < Compras::Model
  attr_accessible :purchase_solicitation_budget_allocation_id, :material_id,
                  :brand, :quantity, :unit_price

  attr_accessor :order

  belongs_to :purchase_solicitation_budget_allocation
  belongs_to :material
  has_one    :purchase_solicitation, :through => :purchase_solicitation_budget_allocation

  delegate :reference_unit, :material_characteristic, :to => :material,
           :allow_nil => true
  delegate :annulled?, :services?,
           :to => :purchase_solicitation_budget_allocation,
           :allow_nil => true

  validates :material, :quantity, :presence => true
  validates :material_id, :uniqueness => { :scope => :purchase_solicitation_budget_allocation_id }, :allow_nil => true
  validate :validate_material_characteristic, :if => :services?

  def self.by_purchase_solicitation(purchase_solicitation)
    joins { purchase_solicitation_budget_allocation }.
    where { purchase_solicitation_budget_allocation.purchase_solicitation_id.eq(purchase_solicitation.id) }
  end

  def self.by_material(material_ids)
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  end

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  private

  def validate_material_characteristic
    return unless material

    unless material.service?
      errors.add(:material, :should_be_service)
    end
  end
end

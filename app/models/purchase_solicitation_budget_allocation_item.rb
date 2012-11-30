class PurchaseSolicitationBudgetAllocationItem < Compras::Model
  attr_accessible :purchase_solicitation_budget_allocation_id, :material_id,
                  :brand, :quantity, :unit_price, :status,
                  :fulfiller_id, :fulfiller_type

  attr_accessor :order

  has_enumeration_for :status, :with => PurchaseSolicitationBudgetAllocationItemStatus
  has_enumeration_for :fulfiller_type

  belongs_to :purchase_solicitation_budget_allocation
  belongs_to :material
  belongs_to :fulfiller, :polymorphic => true

  delegate :reference_unit, :material_characteristic, :to => :material,
           :allow_nil => true
  delegate :annulled?, :services?,
           :to => :purchase_solicitation_budget_allocation,
           :allow_nil => true

  validates :material, :quantity, :unit_price, :status, :presence => true
  validate :validate_material_characteristic, :if => :services?

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

  def self.with_status(status)
    where { |item| item.status.eq status }
  end

  def self.by_material(material_ids)
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  end

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  def fulfill(process)
    if process.present?
      update_fulfiller(process.id, process.class.name)
    else
      update_fulfiller(nil, nil)
    end
  end

  def clear_fulfiller_and_status(status_enumeration = PurchaseSolicitationBudgetAllocationItemStatus)
    update_attributes :fulfiller_id => nil,
                      :fulfiller_type => nil,
                      :status => status_enumeration.value_for(:PENDING)
  end

  def attend!
    update_column :status, PurchaseSolicitationServiceStatus::ATTENDED
  end

  def pending!
    update_column :status, PurchaseSolicitationServiceStatus::PENDING
  end

  private

  def update_fulfiller(process_id, process_name)
    update_attributes :fulfiller_id => process_id,
                      :fulfiller_type => process_name
  end

  def validate_material_characteristic
    return unless material

    unless material.service?
      errors.add(:material, :should_be_service)
    end
  end
end

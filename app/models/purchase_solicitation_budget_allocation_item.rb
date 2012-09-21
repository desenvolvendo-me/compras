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

  def self.by_material(material_ids)
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  end

  def self.fulfill_items(options = {})
    validate_options(options)

    process = options.fetch(:process)
    material_id = options.fetch(:material_id)
    purchase_items = options.fetch(:items) { scoped.by_material(material_id) }

    purchase_items.each { |item| item.update_fulfiller(process) }
  end

  def update_fulfiller(process)
    update_attributes :fulfiller_id => process.id,
                      :fulfiller_type => process.class.name
  end

  private

  def self.validate_options(options)
    raise ArgumentError, 'Expected :process, got nil instead.' unless options[:process].present?
    raise ArgumentError, 'Expected :material_id, got nil instead.' unless options[:material_id].present?
  end
end

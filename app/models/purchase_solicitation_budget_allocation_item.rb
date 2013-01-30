class PurchaseSolicitationBudgetAllocationItem < Compras::Model
  attr_accessible :purchase_solicitation_budget_allocation_id, :material_id,
                  :brand, :quantity, :unit_price, :status,
                  :fulfiller_id, :fulfiller_type

  attr_accessor :order

  has_enumeration_for :status, :with => PurchaseSolicitationBudgetAllocationItemStatus,
                      :create_scopes => true
  has_enumeration_for :fulfiller_type

  belongs_to :purchase_solicitation_budget_allocation
  belongs_to :purchase_solicitation_item_group
  belongs_to :material
  belongs_to :fulfiller, :polymorphic => true
  has_one    :purchase_solicitation, :through => :purchase_solicitation_budget_allocation

  delegate :reference_unit, :material_characteristic, :to => :material,
           :allow_nil => true
  delegate :annulled?, :services?,
           :to => :purchase_solicitation_budget_allocation,
           :allow_nil => true

  validates :material, :quantity, :status, :presence => true
  validates :material_id, :uniqueness => { :scope => :purchase_solicitation_budget_allocation_id }, :allow_nil => true
  validate :validate_material_characteristic, :if => :services?

  def self.group_by_ids!(ids, purchase_solicitation_item_group_id)
    where { id.in(ids) }.update_all(
      :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED,
      :purchase_solicitation_item_group_id => purchase_solicitation_item_group_id
    )
  end

  def self.pending_by_ids!(ids)
    where { id.in(ids) }.update_all(
      :status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING,
      :purchase_solicitation_item_group_id => nil
    )
  end

  def self.by_item_group(item_group)
    where { |item| item.purchase_solicitation_item_group_id.eq(item_group.id) }
  end

  def self.by_purchase_solicitation(purchase_solicitation)
    joins { purchase_solicitation_budget_allocation }.
    where { purchase_solicitation_budget_allocation.purchase_solicitation_id.eq(purchase_solicitation.id) }
  end

  def self.by_material(material_ids)
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  end

  def self.pending!
    update_all(:status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING,
               :purchase_solicitation_item_group_id => nil,
               :fulfiller_id => nil,
               :fulfiller_type => nil)
  end

  def self.attend!
    update_all(:status => PurchaseSolicitationBudgetAllocationItemStatus::ATTENDED)
  end

  def self.partially_fulfilled!
    update_all(:status => PurchaseSolicitationBudgetAllocationItemStatus::PARTIALLY_FULFILLED)
  end

  def self.by_fulfiller(fulfiller_id, fulfiller_type)
    where { |item|
      item.fulfiller_id.eq(fulfiller_id) &
      item.fulfiller_type.eq(fulfiller_type)
    }
  end

  def pending!
    update_column(:status, PurchaseSolicitationBudgetAllocationItemStatus::PENDING)
  end

  def partially_fulfilled!
    update_column(:status, PurchaseSolicitationBudgetAllocationItemStatus::PARTIALLY_FULFILLED)
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

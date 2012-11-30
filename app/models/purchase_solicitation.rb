class PurchaseSolicitation < Compras::Model
  attr_accessible :accounting_year, :request_date, :responsible_id, :kind,
                  :delivery_location_id, :general_observations, :justification,
                  :purchase_solicitation_budget_allocations_attributes,
                  :budget_structure_id

  attr_readonly :code

  auto_increment :code, :by => :accounting_year

  attr_modal :code, :accounting_year, :kind, :delivery_location_id, :budget_structure_id, :responsible_id

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus,
                      :create_helpers => true, :create_scopes => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :budget_structure

  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy,
           :inverse_of => :purchase_solicitation, :order => :id
  has_many :items, :through => :purchase_solicitation_budget_allocations
  has_many :budget_allocations, :through => :purchase_solicitation_budget_allocations,
           :dependent => :restrict
  has_many :purchase_solicitation_liberations, :dependent => :destroy, :order => :sequence
  has_many :purchase_solicitation_item_group_material_purchase_solicitations,
           :dependent => :destroy
  has_one  :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy
  has_one  :direct_purchase

  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :allow_destroy => true

  delegate :amount, :description, :id, :to => :budget_allocation,
           :prefix => true, :allow_nil => true

  validates :request_date, :responsible, :delivery_location, :presence => true
  validates :accounting_year, :kind, :delivery_location, :presence => true
  validates :accounting_year, :numericality => true, :mask => '9999', :allow_blank => true
  validates :purchase_solicitation_budget_allocations, :no_duplication => :budget_allocation_id
  validate :must_have_at_least_one_budget_allocation
  validate :validate_budget_structure_and_materials

  orderize :request_date
  filterize

  scope :by_material_id, lambda { |material_id|
    joins { items }.where { items.material_id.eq(material_id) }
  }

  scope :by_pending_or_ids, lambda { |ids|
    joins { items }.where {
      (items.status.eq(PurchaseSolicitationBudgetAllocationItemStatus::PENDING) | id.in(ids) )
    }
  }

  scope :except_ids, lambda { |ids| where { id.not_in(ids) } }

  scope :with_pending_items, lambda {
    joins { items }.where { items.status.eq(PurchaseSolicitationBudgetAllocationItemStatus::PENDING) }
  }

  scope :can_be_grouped, with_pending_items.where { service_status.in [
    PurchaseSolicitationServiceStatus::LIBERATED,
    PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED ]
  }

  def self.by_material(material_ids)
    joins { items }.
      where { |purchase| purchase.items.material_id.in(material_ids) }
  end

  def to_s
    "#{code}/#{accounting_year} #{budget_structure} - RESP: #{responsible}"
  end

  def can_be_grouped?
    liberated? || partially_fulfilled?
  end

  def total_allocations_items_value
    purchase_solicitation_budget_allocations.collect(&:total_items_value).sum
  end

  def annul!
    update_column :service_status, PurchaseSolicitationServiceStatus::ANNULLED
  end

  def change_status!(status)
    update_column :service_status, status
  end

  def quantity_by_material(material_id)
    PurchaseSolicitation.joins { items }.
      where { |purchase| purchase.items.material_id.eq(material_id) &
                         purchase.id.eq( self.id ) }.sum(:quantity)
  end

  def editable?
    pending? || returned?
  end

  def purchase_solicitation_budget_allocations_by_material(material_ids)
    purchase_solicitation_budget_allocations.by_material(material_ids)
  end

  def budget_structure
    super || direct_purchase.try(:budget_structure)
  end

  def clear_items_fulfiller_and_status
    items.each(&:clear_fulfiller_and_status)
  end

  def liberate!
    update_column :service_status, PurchaseSolicitationServiceStatus::LIBERATED
  end

  def attend!
    update_column :service_status, PurchaseSolicitationServiceStatus::ATTENDED
  end

  def attend_items!
    items.with_status(PurchaseSolicitationBudgetAllocationItemStatus::PENDING).each(&:attend!)
  end

  def rollback_attended_items!
    items.with_status(PurchaseSolicitationBudgetAllocationItemStatus::ATTENDED).each(&:pending!)
  end

  def buy_it!
    update_column :service_status, PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS
  end

  protected

  def must_have_at_least_one_budget_allocation
    unless purchase_solicitation_budget_allocations?
      errors.add(:purchase_solicitation_budget_allocations, :must_have_at_least_one_budget_allocation)
    end
  end

  def purchase_solicitation_budget_allocations?
    !purchase_solicitation_budget_allocations.reject(&:marked_for_destruction?).empty?
  end

  def materials_of_other_peding_purchase_solicitation
    materials = Material.by_pending_purchase_solicitation_budget_structure_id(budget_structure_id)
    materials.not_purchase_solicitation(id)
  end

  def validate_budget_structure_and_materials
    purchase_solicitation_budget_allocations.each do |ps_budget_allocation|
      ps_budget_allocation.items.each do |item|
        if materials_of_other_peding_purchase_solicitation.include?(item.material)
          item.errors.add(:material, :already_exists_a_pending_purchase_solicitation_with_this_budget_structure_and_material)
          errors.add(:base, :invalid)
        end
      end
    end
  end
end

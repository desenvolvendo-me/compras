class PurchaseSolicitation < Compras::Model
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification
  attr_accessible :delivery_location_id, :kind, :general_observations
  attr_accessible :purchase_solicitation_budget_allocations_attributes, :budget_structure_id

  attr_readonly :code

  auto_increment :code, :by => :accounting_year

  attr_modal :accounting_year, :kind, :delivery_location_id, :budget_structure_id

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus,
    :create_helpers => true, :create_scopes => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :budget_structure

  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy, :inverse_of => :purchase_solicitation, :order => :id
  has_many :items, :through => :purchase_solicitation_budget_allocations
  has_many :budget_allocations, :through => :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :purchase_solicitation_item_group_purchase_solicitations, :dependent => :destroy
  has_many :purchase_solicitation_item_groups, :through => :purchase_solicitation_item_group_purchase_solicitations, :dependent => :restrict
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy
  has_one :liberation, :class_name => 'PurchaseSolicitationLiberation', :dependent => :destroy

  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :allow_destroy => true

  delegate :amount, :description, :id, :to => :budget_allocation, :prefix => true, :allow_nil => true
  delegate :id, :to => :liberation, :prefix => true, :allow_nil => true

  validates :request_date, :responsible, :delivery_location, :presence => true
  validates :accounting_year, :kind, :delivery_location, :presence => true
  validates :accounting_year, :numericality => true, :mask => '9999', :allow_blank => true

  validate :must_have_at_least_one_budget_allocation
  validate :cannot_have_duplicated_budget_allocations

  orderize :request_date
  filterize

  scope :by_material_id, lambda { |material_id| joins { items }.where {
    items.material_id.eq(material_id) }}

  scope :by_pending_or_ids, lambda { |ids| joins { items }.where {
    (items.status.eq(PurchaseSolicitationBudgetAllocationItemStatus::PENDING) |
     id.in(ids) )}}

  scope :except_ids, lambda { |ids| where { id.not_in(ids) } }

  def to_s
    "#{code}/#{accounting_year} #{budget_structure} - RESP: #{responsible}"
  end

  def total_allocations_items_value
    purchase_solicitation_budget_allocations.collect(&:total_items_value).sum
  end

  def annul!
    update_attribute :service_status, PurchaseSolicitationServiceStatus::ANNULLED
  end

  def liberate!
    update_attribute :service_status, PurchaseSolicitationServiceStatus::LIBERATED
  end

  def quantity_by_material(material_id)
    PurchaseSolicitation.joins { items }.
      where { |purchase| purchase.items.material_id.eq(material_id) &
                         purchase.id.eq( self.id ) }.sum(:quantity)
  end

  def released?
    liberation.present?
  end

  def releasable?
    pending? && !released?
  end

  protected

  def cannot_have_duplicated_budget_allocations
   single_allocations = []

   purchase_solicitation_budget_allocations.each do |allocation|
     if single_allocations.include?(allocation.budget_allocation_id)
       errors.add(:purchase_solicitation_budget_allocations)
       allocation.errors.add(:budget_allocation_id, :taken)
     end
     single_allocations << allocation.budget_allocation_id
   end
  end

  def must_have_at_least_one_budget_allocation
    unless purchase_solicitation_budget_allocations?
      errors.add(:purchase_solicitation_budget_allocations, :must_have_at_least_one_budget_allocation)
    end
  end

  def purchase_solicitation_budget_allocations?
    !purchase_solicitation_budget_allocations.reject(&:marked_for_destruction?).empty?
  end
end

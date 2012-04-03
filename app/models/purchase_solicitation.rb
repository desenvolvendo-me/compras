class PurchaseSolicitation < ActiveRecord::Base
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification
  attr_accessible :delivery_location_id, :kind, :general_observations
  attr_accessible :purchase_solicitation_budget_allocations_attributes, :organogram_id
  attr_accessible :expense_economic_classification_id

  attr_modal :accounting_year, :kind, :delivery_location_id, :organogram_id

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus, :create_helpers => true

  belongs_to :expense_economic_classification
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :organogram

  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy, :inverse_of => :purchase_solicitation, :order => :id
  has_many :budget_allocations, :through => :purchase_solicitation_budget_allocations, :dependent => :restrict

  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :allow_destroy => true

  delegate :amount, :description, :id, :to => :budget_allocation, :prefix => true, :allow_nil => true

  validates :request_date, :responsible, :delivery_location, :kind, :delivery_location, :presence => true
  validates :accounting_year, :presence => true, :numericality => true, :mask => '9999'

  validate :must_have_at_least_budget_allocation
  validate :cannot_have_duplicated_budget_allocations

  orderize :request_date
  filterize


  def to_s
    id.to_s
  end

  def budget_allocations_total_value
    purchase_solicitation_budget_allocations.collect { |item| item.estimated_value || 0 }.sum
  end

  def total_allocations_items_value
    purchase_solicitation_budget_allocations.collect(&:total_items_value).sum
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

  def must_have_at_least_budget_allocation
    if purchase_solicitation_budget_allocations.empty?
      errors.add(:purchase_solicitation_budget_allocations, :must_have_at_least_one_budget_allocation)
    end
  end
end

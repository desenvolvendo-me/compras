class PurchaseSolicitation < ActiveRecord::Base
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification, :budget_allocation_id,
                  :delivery_location_id, :kind, :general_observations, :items_attributes, :purchase_solicitation_budget_allocations_attributes,
                  :organogram_id, :expense_economic_classification_id

  attr_modal :accounting_year, :kind, :delivery_location_id, :organogram_id

  delegate :amount, :description, :id, :to => :budget_allocation, :prefix => true, :allow_nil => true

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus, :create_helpers => true

  belongs_to :expense_economic_classification
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :budget_allocation
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :organogram
  has_many :items, :class_name => 'PurchaseSolicitationItem', :dependent => :destroy, :inverse_of => :purchase_solicitation
  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy, :inverse_of => :purchase_solicitation
  has_many :budget_allocations, :through => :purchase_solicitation_budget_allocations, :dependent => :restrict

  before_save :clean_extra_budget_allocations

  validates :request_date, :responsible_id, :delivery_location, :kind, :delivery_location_id, :presence => true
  validates :accounting_year, :presence => true, :numericality => true, :mask => '9999'
  validate :cannot_have_more_than_once_item_with_the_same_material
  validate :cannot_have_duplicated_budget_allocations
  validate :budget_allocations_total_value_must_be_equal_to_items_total_value

  orderize :request_date
  filterize

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    id.to_s
  end

  def budget_allocations_total_value
    purchase_solicitation_budget_allocations.collect { |item| item.estimated_value || 0 }.sum
  end

  def items_total_value
    items.collect { |item| item.estimated_total_price || 0 }.sum
  end

  protected

  def clean_extra_budget_allocations
    if budget_allocation.present?
      self.budget_allocation_ids = []
    end
  end

  def cannot_have_more_than_once_item_with_the_same_material
    single_materials = []

    items.each do |item|
      if single_materials.include?(item.material_id)
        errors.add(:items)
        item.errors.add(:material_id, :cannot_have_more_than_once_item_with_the_same_material)
      end
      single_materials << item.material_id
    end
  end

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

  def budget_allocations_total_value_must_be_equal_to_items_total_value
    return if budget_allocation_id?

    if items_total_value != budget_allocations_total_value
      errors.add(:budget_allocations_total_value, :must_be_equal_to_items_total_value)
    end
  end
end

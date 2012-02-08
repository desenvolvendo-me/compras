class PurchaseSolicitation < ActiveRecord::Base
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification, :budget_allocation_id,
                  :delivery_location_id, :kind, :general_observations, :items_attributes, :purchase_solicitation_budget_allocations_attributes,
                  :organogram_id

  attr_protected :allocation_amount, :service_status, :liberation_date, :liberator, :service_observations,
                 :no_service_justification, :responsible, :liberator_id, :budget_allocation, :delivery_location,
                 :organogram

  delegate :amount, :to => :budget_allocation, :prefix => 'budget_allocation', :allow_nil => true

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus, :create_helpers => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :budget_allocation
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :organogram
  has_many :items, :class_name => 'PurchaseSolicitationItem', :dependent => :destroy, :inverse_of => :purchase_solicitation
  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy, :inverse_of => :purchase_solicitation
  has_many :budget_allocations, :through => :purchase_solicitation_budget_allocations

  before_save :clean_extra_budget_allocations

  validates :accounting_year, :request_date, :responsible_id,
            :delivery_location, :kind, :delivery_location_id, :presence => true
  validate :cannot_have_more_than_once_item_with_the_same_material
  validate :cannot_have_duplicated_budget_allocations
  validate :sum_of_items_must_be_equal_to_sum_of_allocations

  orderize :request_date
  filterize

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    justification
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
        item.errors.add(:material_id, :cannot_have_more_than_once_item_with_the_same_material)
        errors.add(:items)
      end
      single_materials << item.material_id
    end
  end

  def cannot_have_duplicated_budget_allocations
   single_allocations = []

   purchase_solicitation_budget_allocations.each do |allocation|
     if single_allocations.include?(allocation.budget_allocation_id)
       allocation.errors.add(:budget_allocation_id, :taken)
     end
     single_allocations << allocation.budget_allocation_id
   end
  end

  def sum_of_items_must_be_equal_to_sum_of_allocations
    unless budget_allocation_id
      items_total = items.collect{ |item| item.estimated_total_price || 0 }.sum
      allocations_total = purchase_solicitation_budget_allocations.collect{ |allocation| allocation.estimated_value || 0 }.sum
      if items_total != allocations_total
        errors.add(:budget_allocations_total_value, :must_be_equal_to_items_total_value)
      end
    end
  end
end

class DirectPurchase < Compras::Model
  attr_accessible :direct_purchase, :year, :date, :legal_reference_id, :modality, :creditor_id, :budget_structure_id
  attr_accessible :licitation_object_id, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :price_collection, :price_registration, :observation, :pledge_type
  attr_accessible :direct_purchase_budget_allocations_attributes, :period, :period_unit

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality
  has_enumeration_for :pledge_type, :with => DirectPurchasePledgeType
  has_enumeration_for :period_unit, :with => PeriodUnit

  belongs_to :legal_reference
  belongs_to :creditor
  belongs_to :budget_structure
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method

  has_many :direct_purchase_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :direct_purchase_budget_allocations, :class_name => :DirectPurchaseBudgetAllocationItem
  has_one :supply_authorization, :dependent => :restrict

  accepts_nested_attributes_for :direct_purchase_budget_allocations, :allow_destroy => true

  delegate :phone, :fax, :address, :city, :zip_code, :to => :creditor, :allow_nil => true
  delegate :accounts, :agencies, :banks, :to => :creditor, :allow_nil => true
  delegate :purchase_licitation_exemption, :build_licitation_exemption,
           :to => :licitation_object, :allow_nil => true, :prefix => true
  delegate :materials, :materials_groups, :materials_classes,
           :to => :creditor, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :year, :date, :legal_reference, :modality, :presence => true
  validates :budget_structure, :licitation_object, :delivery_location, :presence => true
  validates :creditor, :employee, :payment_method, :pledge_type, :presence => true
  validates :period, :period_unit, :presence => true

  validate :cannot_have_duplicated_budget_allocations
  validate :must_have_at_least_budget_allocation
  validate :total_value_of_items_should_not_be_greater_than_modality_limit_value

  orderize :year

  def to_s
    "#{direct_purchase}/#{year}"
  end

  def next_purchase
    last_purchase_of_self_year.succ
  end

  def licitation_exemption
    return 0 if licitation_object.nil? || modality.empty?

    licitation_object.licitation_exemption(modality)
  end

  def total_allocations_items_value
    direct_purchase_budget_allocations.collect(&:total_items_value).sum
  end

  def self.filter(params={})
    relation = scoped
    relation = relation.where{ year.eq(params[:year]) } unless params[:year].blank?
    relation = relation.where{ date.eq(params[:date].to_date) } if !params[:date].blank? && params[:date].date?
    relation = relation.where{ modality.eq(params[:modality]) } unless params[:modality].blank?
    relation
  end

  def authorized?
    supply_authorization.present?
  end

  protected

  def cannot_have_duplicated_budget_allocations
   single_allocations = []

   direct_purchase_budget_allocations.each do |allocation|
     if single_allocations.include?(allocation.budget_allocation_id)
       errors.add(:direct_purchase_budget_allocations)
       allocation.errors.add(:budget_allocation_id, :taken)
     end
     single_allocations << allocation.budget_allocation_id
   end
  end

  def must_have_at_least_budget_allocation
    if direct_purchase_budget_allocations.empty?
      errors.add(:direct_purchase_budget_allocations, :must_have_at_least_one_budget_allocation)
    end
  end

  def total_value_of_items_should_not_be_greater_than_modality_limit_value(limit_validator = DirectPurchaseModalityLimitVerificator)
    return if licitation_object.nil? || modality.blank?

    unless limit_validator.new(self).value_less_than_available_limit?
      errors.add(:total_allocations_items_value, :greater_than_actual_modality_limit)
    end
  end

  def last_purchase_of_self_year
    self.class.where { self.year.eq(year) }.maximum(:direct_purchase).to_i
  end
end

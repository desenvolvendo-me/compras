class DirectPurchase < Compras::Model
  attr_accessible :code, :year, :date, :legal_reference_id,
                  :modality, :creditor_id, :budget_structure_id,
                  :licitation_object_id, :delivery_location_id, :employee_id,
                  :payment_method_id, :price_collection, :observation,
                  :pledge_type, :delivery_term, :delivery_term_period,
                  :direct_purchase_budget_allocations_attributes,
                  :total_allocations_items_value, :purchase_solicitation_id

  attr_modal :code, :year, :date, :modality,
             :budget_structure_id, :creditor_id

  auto_increment :code, :by => :year

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality
  has_enumeration_for :pledge_type, :with => DirectPurchasePledgeType
  has_enumeration_for :delivery_term_period, :with => PeriodUnit
  has_enumeration_for :status, :with => DirectPurchaseStatus

  belongs_to :legal_reference
  belongs_to :creditor
  belongs_to :budget_structure
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method
  belongs_to :purchase_solicitation

  has_many :direct_purchase_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :direct_purchase_budget_allocations, :class_name => :DirectPurchaseBudgetAllocationItem
  has_many :materials, :through => :items

  has_one :supply_authorization, :dependent => :restrict
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  accepts_nested_attributes_for :direct_purchase_budget_allocations, :allow_destroy => true

  delegate :phone, :fax, :address, :city, :zip_code, :to => :creditor, :allow_nil => true
  delegate :person_email, :to => :creditor, :allow_nil => true, :prefix => true
  delegate :accounts, :agencies, :banks, :to => :creditor, :allow_nil => true
  delegate :purchase_licitation_exemption, :build_licitation_exemption,
           :to => :licitation_object, :allow_nil => true, :prefix => true
  delegate :materials, :materials_classes,
           :to => :creditor, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :year, :date, :legal_reference, :modality, :presence => true
  validates :licitation_object, :delivery_location, :presence => true
  validates :budget_structure, :presence => true
  validates :creditor, :employee, :payment_method, :pledge_type, :presence => true
  validates :delivery_term, :delivery_term_period, :presence => true
  validates :direct_purchase_budget_allocations, :no_duplication => :budget_allocation_id

  validate :must_have_at_least_budget_allocation
  validate :total_value_of_items_should_not_be_greater_than_modality_limit_value
  validate :purchase_solicitation_can_generate_direct_purchase

  before_validation :set_total_allocations_items_value

  orderize "year DESC, code DESC"
  filterize

  def to_s
    "#{code}/#{year}"
  end

  def annulled?
    annul.present?
  end

  def annullable?
    !annulled?
  end

  def next_purchase
    last_purchase_of_self_year.succ
  end

  def licitation_exemption
    return BigDecimal(0) if licitation_object.nil? || modality.empty?

    licitation_object.licitation_exemption(modality)
  end

  def authorized?
    supply_authorization.present?
  end

  def total_direct_purchase_budget_allocations_sum
    direct_purchase_budget_allocations.
      reject(&:marked_for_destruction?).
      sum(&:total_items_value)
  end

  def remove_purchase_solicitation!
    update_column(:purchase_solicitation_id, nil)
  end

  def status
    if annulled?
      DirectPurchaseStatus::ANNULLED
    else
      DirectPurchaseStatus::COMPLETED
    end
  end

  def fulfill_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.fulfill(self)
    end
  end

  def remove_fulfill_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.fulfill(nil)
    end
  end

  def partially_fulfilled_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.partially_fulfilled!
    end
  end

  def attend_purchase_solicitation_items
    purchase_solicitation_items.attend!
  end

  protected

  def must_have_at_least_budget_allocation
    if direct_purchase_budget_allocations.empty?
      errors.add(:direct_purchase_budget_allocations, :must_have_at_least_one_budget_allocation)
    end
  end

  def total_value_of_items_should_not_be_greater_than_modality_limit_value(limit_validator = DirectPurchaseModalityLimitVerificator,
                                                                           numeric_parser = ::I18n::Alchemy::NumericParser)
    return if licitation_object.nil? || modality.blank?

    validator = limit_validator.new(self)

    unless validator.value_less_than_available_limit?
      errors.add(:total_allocations_items_value, :greater_than_actual_object_limit,
                 :target => licitation_object, :limit => numeric_parser.localize(validator.current_limit))
    end
  end

  def set_total_allocations_items_value
    self.total_allocations_items_value = total_direct_purchase_budget_allocations_sum
  end

  def purchase_solicitation_can_generate_direct_purchase
    return if purchase_solicitation.blank? || !purchase_solicitation_id_changed?

    unless purchase_solicitation.can_be_grouped?
      errors.add(:purchase_solicitation, :cannot_generate_direct_purchase)
    end
  end

  def material_ids_or_zero
    return 0 if material_ids.size == 0

    material_ids.join(',')
  end
end

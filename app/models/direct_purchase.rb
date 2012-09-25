class DirectPurchase < Compras::Model
  attr_accessible :direct_purchase, :year, :date, :legal_reference_id,
                  :modality, :creditor_id, :budget_structure_id,
                  :licitation_object_id, :delivery_location_id, :employee_id,
                  :payment_method_id, :price_collection, :price_registration_id,
                  :observation, :pledge_type, :delivery_term, :delivery_term_period,
                  :direct_purchase_budget_allocations_attributes,
                  :total_allocations_items_value, :purchase_solicitation_id,
                  :purchase_solicitation_item_group_id

  attr_modal :year, :date, :modality

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality
  has_enumeration_for :pledge_type, :with => DirectPurchasePledgeType
  has_enumeration_for :delivery_term_period, :with => PeriodUnit

  belongs_to :legal_reference
  belongs_to :creditor
  belongs_to :budget_structure
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method
  belongs_to :purchase_solicitation
  belongs_to :purchase_solicitation_item_group
  belongs_to :price_registration

  has_many :direct_purchase_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :direct_purchase_budget_allocations, :class_name => :DirectPurchaseBudgetAllocationItem
  has_many :purchase_solicitation_budget_allocation_items, :as => :fulfiller
  has_one :supply_authorization, :dependent => :restrict

  accepts_nested_attributes_for :direct_purchase_budget_allocations, :allow_destroy => true

  delegate :phone, :fax, :address, :city, :zip_code, :to => :creditor, :allow_nil => true
  delegate :person_email, :to => :creditor, :allow_nil => true, :prefix => true
  delegate :accounts, :agencies, :banks, :to => :creditor, :allow_nil => true
  delegate :purchase_licitation_exemption, :build_licitation_exemption,
           :to => :licitation_object, :allow_nil => true, :prefix => true
  delegate :materials, :materials_groups, :materials_classes,
           :to => :creditor, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :year, :date, :legal_reference, :modality, :presence => true
  validates :licitation_object, :delivery_location, :presence => true
  validates :budget_structure, :presence => true,
            :unless => lambda { |purchase| purchase.purchase_solicitation.present? ||
                                           purchase.purchase_solicitation_item_group.present? }
  validates :creditor, :employee, :payment_method, :pledge_type, :presence => true
  validates :delivery_term, :delivery_term_period, :presence => true
  validates :direct_purchase_budget_allocations, :no_duplication => :budget_allocation_id

  validate :must_have_at_least_budget_allocation
  validate :total_value_of_items_should_not_be_greater_than_modality_limit_value
  validate :purchase_solicitation_item_group_annulled

  before_validation :set_total_allocations_items_value

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

  def self.filter(params)
    query = scoped
    query = query.where{ year.eq(params[:year]) } unless params[:year].blank?
    query = query.where{ date.eq(params[:date].to_date) } if !params[:date].blank? && params[:date].date?
    query = query.where{ modality.eq(params[:modality]) } unless params[:modality].blank?
    query
  end

  def authorized?
    supply_authorization.present?
  end

  def total_direct_purchase_budget_allocations_sum
    direct_purchase_budget_allocations.collect(&:total_items_value).sum
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

  def last_purchase_of_self_year
    self.class.where { self.year.eq(year) }.maximum(:direct_purchase).to_i
  end

  def set_total_allocations_items_value
    self.total_allocations_items_value = total_direct_purchase_budget_allocations_sum
  end

  def purchase_solicitation_item_group_annulled
    return unless purchase_solicitation_item_group.present?

    if purchase_solicitation_item_group.annulled?
      errors.add(:purchase_solicitation_item_group, :is_annulled)
    end
  end
end

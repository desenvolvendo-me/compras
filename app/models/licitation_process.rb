class LicitationProcess < Compras::Model
  attr_accessible :administrative_process_id, :capability_id, :payment_method_id, :year, :process_date
  attr_accessible :readjustment_index_id, :caution_value, :legal_advice, :legal_advice_date
  attr_accessible :contract_date, :contract_expiration, :observations, :envelope_delivery_date
  attr_accessible :envelope_delivery_time, :envelope_opening_date, :envelope_opening_time, :document_type_ids
  attr_accessible :pledge_type, :administrative_process_attributes, :type_of_calculation
  attr_accessible :period, :period_unit, :expiration, :expiration_unit
  attr_accessible :licitation_process_bidders_attributes, :judgment_form_id
  attr_accessible :disqualify_by_documentation_problem, :disqualify_by_maximum_value, :consider_law_of_proposals

  attr_readonly :process, :year, :licitation_number

  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process_id

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :modality, :with => AbreviatedProcessModality, :create_helpers => true
  has_enumeration_for :pledge_type
  has_enumeration_for :type_of_calculation, :with => LicitationProcessTypeOfCalculation
  has_enumeration_for :expiration_unit, :with => PeriodUnit
  has_enumeration_for :period_unit, :with => PeriodUnit

  belongs_to :administrative_process
  belongs_to :capability
  belongs_to :payment_method
  belongs_to :readjustment_index, :class_name => 'Indexer'
  belongs_to :judgment_form

  has_and_belongs_to_many :document_types, :join_table => :compras_document_types_compras_licitation_processes

  has_many :licitation_process_publications, :dependent => :destroy, :order => :id
  has_many :licitation_process_bidders, :dependent => :destroy, :order => :id
  has_many :licitation_process_impugnments, :dependent => :restrict, :order => :id
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :judgment_commission_advices, :dependent => :restrict
  has_many :licitation_notices, :dependent => :destroy
  has_many :creditors, :through => :licitation_process_bidders, :dependent => :restrict
  has_many :licitation_process_lots, :dependent => :destroy, :order => :id
  has_many :reserve_funds, :dependent => :restrict
  has_many :record_prices, :dependent => :restrict

  accepts_nested_attributes_for :licitation_process_bidders, :allow_destroy => true
  accepts_nested_attributes_for :administrative_process, :allow_destroy => true

  delegate :modality, :modality_humanize, :object_type_humanize, :presence_trading?,
           :released?, :judgment_form, :description, :responsible,
           :item, :licitation_process, :date, :object_type, :judgment_form_kind,
           :to => :administrative_process, :allow_nil => true, :prefix => true

  delegate :administrative_process_budget_allocations, :items, :to => :administrative_process, :allow_nil => true
  delegate :is_available_for_licitation_process_classification?, :items, :to => :administrative_process, :allow_nil => true

  validates :process_date, :administrative_process, :capability, :presence => true
  validates :period, :period_unit, :expiration, :expiration_unit, :presence => true
  validates :payment_method, :envelope_delivery_time, :year, :presence => true
  validates :envelope_delivery_date, :envelope_opening_date, :envelope_opening_time, :pledge_type, :presence => true
  validates :type_of_calculation, :presence => true
  validate :total_of_administrative_process_budget_allocations_items_must_be_less_or_equal_to_value
  validate :administrative_process_must_not_belong_to_another_licitation_process
  validate :validate_type_of_calculation_by_judgment_form_kind
  validate :validate_type_of_calculation_by_object_type
  validate :validate_type_of_calculation_by_modality
  validate :validate_administrative_process_status
  validate :validate_administrative_process
  validate :validate_administrative_process_allow_licitation_process

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => "9999"
    allowing_blank.validates :envelope_delivery_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create
      }
    allowing_blank.validates :envelope_opening_date,
      :timeliness => {
        :on_or_after => :envelope_delivery_date,
        :on_or_after_message => :should_be_on_or_after_envelope_delivery_date,
        :type => :date,
        :on => :create
      }
    allowing_blank.validates :envelope_delivery_time, :envelope_opening_time, :timeliness => { :type => :time }
    allowing_blank.validates :process_date,
      :timeliness => {
        :on_or_after => :administrative_process_date,
        :on_or_after_message => :should_be_on_or_after_administrative_process_date,
        :type => :date
      }
  end

  before_save :set_modality

  before_update :assign_bidders_documents

  orderize :id
  filterize

  def to_s
    "#{process}/#{year}"
  end

  def next_process
    last_process_of_self_year.succ
  end

  def next_licitation_number
    last_licitation_number_of_self_year_and_modality.succ
  end

  def advice_number
    judgment_commission_advices.count
  end

  def allow_bidders?
    envelope_opening?
  end

  def envelope_opening?
    return unless envelope_opening_date
    envelope_opening_date == Date.current
  end

  def updatable?
    new_record? || licitation_process_publications.empty? || licitation_process_publications.current_updatable?
  end

  def filled_lots?
    items && !items.without_lot?
  end

  def all_licitation_process_classifications
    licitation_process_bidders.classifications
  end

  def destroy_all_licitation_process_classifications
    licitation_process_bidders.destroy_all_classifications
  end

  def lots_with_items
    licitation_process_lots.select do |lot|
      !lot.administrative_process_budget_allocation_items.empty? && !lot.licitation_process_bidder_proposals.empty?
    end
  end

  def has_bidders_and_is_available_for_classification
    !licitation_process_bidders.empty? && is_available_for_licitation_process_classification?
  end

  protected

  def set_modality
    self.modality = administrative_process.modality
  end

  def validate_administrative_process_status
    unless administrative_process_released?
      errors.add(:administrative_process, :status_must_be_released)
    end
  end

  def validate_administrative_process
    return unless administrative_process.try(:licitation_process)

    if administrative_process.licitation_process == self
      return
    end

    errors.add(:administrative_process, :already_have_a_licitation_process)
  end

  def last_process_of_self_year
    self.class.where { self.year.eq(year) }.maximum(:process).to_i
  end

  def last_licitation_number_of_self_year_and_modality
    self.class.where { self.year.eq(year) & self.modality.eq(modality) }.
               maximum(:licitation_number).to_i
  end

  def total_of_administrative_process_budget_allocations_items_must_be_less_or_equal_to_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return if administrative_process_budget_allocations.blank?

    administrative_process_budget_allocations.each do |apba|
      if apba.total_items_value > apba.value
        errors.add(:administrative_process_budget_allocations)
        apba.errors.add(:total_items_value, :less_than_or_equal_to_predicted_value, :count => numeric_parser.localize(apba.value))
      end
    end
  end

  def administrative_process_must_not_belong_to_another_licitation_process
    return if administrative_process.nil? || administrative_process_licitation_process == self

    unless administrative_process_licitation_process.nil?
      errors.add(:administrative_process, :taken)
    end
  end

  def assign_bidders_documents
    return unless allow_bidders?

    licitation_process_bidders.each(&:assign_document_types)
  end

  def validate_type_of_calculation_by_judgment_form_kind(verificator = LicitationProcessTypesOfCalculationByJudgmentFormKind.new)
    return if type_of_calculation.nil? || administrative_process_judgment_form_kind.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_judgment_form_kind, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_judgment_form_kind, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_type_of_calculation_by_object_type(verificator = LicitationProcessTypesOfCalculationByObjectType.new)
    return if type_of_calculation.nil? || administrative_process_object_type.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_object_type, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_object_type, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_type_of_calculation_by_modality(verificator = LicitationProcessTypesOfCalculationByModality.new)
    return if type_of_calculation.nil? || administrative_process_modality.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_modality, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_modality, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_administrative_process_allow_licitation_process
    return if administrative_process.nil?

    unless administrative_process.allow_licitation_process?
      errors.add(:administrative_process, :not_allow_licitation_process)
    end
  end
end

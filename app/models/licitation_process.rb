class LicitationProcess < ActiveRecord::Base
  attr_accessible :administrative_process_id, :capability_id, :period_id, :payment_method_id, :year, :process_date
  attr_accessible :object_description, :expiration, :readjustment_index, :caution_value, :legal_advice
  attr_accessible :legal_advice_date, :contract_date, :contract_expiration, :observations, :envelope_delivery_date
  attr_accessible :envelope_delivery_time, :envelope_opening_date, :envelope_opening_time, :document_type_ids
  attr_accessible :licitation_process_publications_attributes
  attr_accessible :pledge_type, :administrative_process_attributes, :type_of_calculation

  attr_readonly :process, :year, :licitation_number

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :modality, :with => AbreviatedProcessModality, :create_helpers => true
  has_enumeration_for :pledge_type
  has_enumeration_for :type_of_calculation, :with => LicitationProcessTypeOfCalculation

  belongs_to :administrative_process
  belongs_to :capability
  belongs_to :period
  belongs_to :payment_method

  has_and_belongs_to_many :document_types

  has_many :licitation_process_publications, :dependent => :destroy, :order => :id
  has_many :licitation_process_bidders, :dependent => :destroy, :order => :id, :autosave => true
  has_many :licitation_process_impugnments, :dependent => :restrict, :order => :id
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :judgment_commission_advices, :dependent => :restrict
  has_many :licitation_notices, :dependent => :destroy
  has_many :providers, :through => :licitation_process_bidders, :dependent => :restrict
  has_many :licitation_process_lots, :dependent => :destroy, :order => :id

  has_one :accreditation, :dependent => :destroy

  accepts_nested_attributes_for :licitation_process_publications, :allow_destroy => true

  accepts_nested_attributes_for :administrative_process, :allow_destroy => true

  delegate :budget_unit, :modality, :modality_humanize, :object_type_humanize, :judgment_form, :description, :responsible,
           :item, :licitation_process, :date, :object_type, :judgment_form_kind,
           :to => :administrative_process, :allow_nil => true, :prefix => true

  delegate :administrative_process_budget_allocations, :items, :to => :administrative_process, :allow_nil => true

  validates :process_date, :administrative_process, :object_description, :capability, :expiration, :presence => true
  validates :readjustment_index, :period, :payment_method, :envelope_delivery_time, :year, :presence => true
  validates :envelope_delivery_date, :envelope_opening_date, :envelope_opening_time, :pledge_type, :presence => true
  validates :type_of_calculation, :presence => true
  validate :total_of_administrative_process_budget_allocations_items_must_be_equal_to_value
  validate :administrative_process_must_not_belong_to_another_licitation_process
  validate :validate_type_of_calculation_by_judgment_form_kind
  validate :validate_type_of_calculation_by_object_type
  validate :validate_type_of_calculation_by_modality

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => "9999"
    allowing_blank.validates :envelope_delivery_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create }
    allowing_blank.validates :envelope_opening_date, :timeliness => { :on_or_after => :envelope_delivery_date, :type => :date, :on => :create }
    allowing_blank.validates :envelope_delivery_time, :envelope_opening_time, :timeliness => { :type => :time }
    allowing_blank.validates :process_date, :timeliness => { :on_or_after => :administrative_process_date, :type => :date }
  end

  before_save :set_modality

  before_update :clean_old_administrative_process_items
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

  def can_have_bidders?
    return unless envelope_opening_date
    envelope_opening_date <= Date.current
  end

  def envelope_opening?
    return unless envelope_opening_date
    envelope_opening_date == Date.current
  end

  # TODO change this to updatable?
  def can_update?
    new_record? || licitation_process_publications.empty? || any_publication_that_permit_update?
  end

  def filled_lots?
    items && !items.without_lot?
  end

  def winner_proposal_provider()
    return unless winner_proposal

    winner_proposal.provider
  end

  def winner_proposal_total_price
    return unless winner_proposal

    winner_proposal.proposal_total_value
  end

  protected

  def winner_proposal
    licitation_process_bidders.min_by(&:proposal_total_value)
  end

  def set_modality
    self.modality = administrative_process.modality
  end

  def last_process_of_self_year
    last_by_self_year.try(:process).to_i
  end

  def last_by_self_year
    self.class.where { |p| p.year.eq(year) }.order { id }.last
  end

  def last_licitation_number_of_self_year_and_modality
    last_by_self_year_and_modality.try(:licitation_number).to_i
  end

  def last_by_self_year_and_modality
    self.class.where { |p| p.year.eq(year) & p.modality.eq(modality) }.
               order { id }.last
  end

  def total_of_administrative_process_budget_allocations_items_must_be_equal_to_value
    return if administrative_process_budget_allocations.blank?

    administrative_process_budget_allocations.each do |apba|
      if apba.total_items_value != apba.value
        errors.add(:administrative_process_budget_allocations)
        apba.errors.add(:total_items_value, :must_be_equal_to_estimated_value)
      end
    end
  end

  def administrative_process_must_not_belong_to_another_licitation_process
    return if administrative_process.nil? || administrative_process_licitation_process == self

    unless administrative_process_licitation_process.nil?
      errors.add(:administrative_process, :taken)
    end
  end

  def clean_old_administrative_process_items
    if administrative_process_id_changed?
      AdministrativeProcessItemsCleaner.new(administrative_process_id_was).clean_items!
    end
  end

  def assign_bidders_documents
    return unless can_have_bidders?

    licitation_process_bidders.each(&:assign_document_types)
  end

  def validate_type_of_calculation_by_judgment_form_kind(verificator = LicitationProcessTypesOfCalculationByJudgmentFormKind.new)
    return if type_of_calculation.nil? || administrative_process_judgment_form_kind.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_judgment_form_kind, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_judgment_form_kind)
    end
  end

  def validate_type_of_calculation_by_object_type(verificator = LicitationProcessTypesOfCalculationByObjectType.new)
    return if type_of_calculation.nil? || administrative_process_object_type.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_object_type, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_object_type)
    end
  end

  def validate_type_of_calculation_by_modality(verificator = LicitationProcessTypesOfCalculationByModality.new)
    return if type_of_calculation.nil? || administrative_process_modality.nil?

    unless verificator.correct_type_of_calculation?(administrative_process_modality, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_modality)
    end
  end

  private

  def any_publication_that_permit_update?
    licitation_process_publications.any_publication_that_permit_the_licitation_process_update?
  end
end

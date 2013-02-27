class LicitationProcess < Compras::Model
  attr_accessible :capability_id, :payment_method_id,
                  :year, :process_date,:readjustment_index_id, :caution_value,
                  :legal_advice, :legal_advice_date, :contract_date,
                  :contract_expiration, :observations, :envelope_delivery_date,
                  :envelope_delivery_time, :envelope_opening_date,
                  :envelope_opening_time, :document_type_ids, :type_of_calculation,
                  :period, :period_unit, :expiration, :expiration_unit,
                  :judgment_form_id, :delivery_location_id, :execution_type,
                  :disqualify_by_documentation_problem, :disqualify_by_maximum_value,
                  :consider_law_of_proposals, :price_registration, :status,
                  :responsible_id, :purchase_solicitation_id, :object_type,
                  :date, :protocol, :item, :purchase_solicitation_item_group_id,
                  :summarized_object, :modality, :description, :pledge_type,
                  :administrative_process_budget_allocations_attributes

  auto_increment :process, :by => :year

  attr_readonly :process, :year, :licitation_number

  attr_modal :process, :year, :process_date, :licitation_number

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :pledge_type
  has_enumeration_for :type_of_calculation, :with => LicitationProcessTypeOfCalculation, :create_helpers => true
  has_enumeration_for :expiration_unit, :with => PeriodUnit
  has_enumeration_for :period_unit, :with => PeriodUnit
  has_enumeration_for :status, :with => LicitationProcessStatus, :create_helpers => true
  has_enumeration_for :execution_type
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true
  has_enumeration_for :object_type, :with => AdministrativeProcessObjectType,
                      :create_helpers => true

  belongs_to :capability
  belongs_to :delivery_location
  belongs_to :judgment_form
  belongs_to :payment_method
  belongs_to :purchase_solicitation
  belongs_to :purchase_solicitation_item_group
  belongs_to :readjustment_index, :class_name => 'Indexer'
  belongs_to :responsible, :class_name => 'Employee'

  has_and_belongs_to_many :document_types, :join_table => :compras_document_types_compras_licitation_processes

  has_many :licitation_process_publications, :dependent => :destroy, :order => :id
  has_many :bidders, :dependent => :destroy, :order => :id
  has_many :licitation_process_impugnments, :dependent => :restrict, :order => :id
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :judgment_commission_advices, :dependent => :restrict
  has_many :licitation_notices, :dependent => :destroy
  has_many :creditors, :through => :bidders, :dependent => :restrict
  has_many :licitation_process_lots, :dependent => :destroy, :order => :id
  has_many :reserve_funds, :dependent => :restrict
  has_many :price_registrations, :dependent => :restrict
  has_many :licitation_process_ratifications, :dependent => :restrict, :order => :id
  has_many :classifications, :through => :bidders, :class_name => 'LicitationProcessClassification',
           :source => :licitation_process_classifications
  has_many :administrative_process_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :administrative_process_budget_allocations, :order => :id

  has_one :trading, :dependent => :restrict

  accepts_nested_attributes_for :administrative_process_budget_allocations, :allow_destroy => true

  delegate :kind, :best_technique?, :technical_and_price?,
           :to => :judgment_form, :allow_nil => true, :prefix => true
  delegate :delivery_location, :to => :purchase_solicitation, :allow_nil => true,
           :prefix => true
  delegate :licitation_kind, :to => :judgment_form, :allow_nil => true, :prefix => true

  validates :process_date, :capability, :period,
            :period_unit, :expiration, :expiration_unit, :payment_method,
            :envelope_delivery_time, :year, :envelope_delivery_date,
            :pledge_type, :type_of_calculation, :execution_type, :object_type,
            :modality, :judgment_form_id, :responsible, :description,
            :presence => true
  validate :validate_type_of_calculation_by_judgment_form_kind
  validate :validate_type_of_calculation_by_object_type
  validate :validate_type_of_calculation_by_modality
  validate :validate_bidders_before_edital_publication
  validate :validate_updates, :unless => :updatable?
  validate :validate_envelope_opening_date, :on => :update

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => "9999"
    allowing_blank.validates :envelope_delivery_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create,
        :unless => :allow_insert_past_processes?
      }
    allowing_blank.validates :envelope_opening_date,
      :timeliness => {
        :on_or_after => :envelope_delivery_date,
        :on_or_after_message => :should_be_on_or_after_envelope_delivery_date,
        :type => :date,
        :on => :create
      }
    allowing_blank.validates :envelope_delivery_time, :envelope_opening_time,
      :timeliness => {
        :type => :time,
        :on => :update
      }
  end

  before_update :assign_bidders_documents

  orderize "id DESC"
  filterize

  scope :with_price_registrations, where { price_registration.eq true }

  scope :without_trading, lambda { |except_id|
    joins { trading.outer }.
    where { |licitation| licitation.trading.id.eq(nil) | licitation.id.eq(except_id) }
  }

  def self.published_edital
    joins { licitation_process_publications }.where {
      licitation_process_publications.publication_of.eq PublicationOf::EDITAL
    }
  end

  def to_s
    "#{process}/#{year}"
  end

  def update_status(status)
    update_column :status, status
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
    new_record? || ((licitation_process_ratifications.empty? || licitation_process_publications.empty?) && licitation_process_publications.current_updatable?)
  end

  def filled_lots?
    items && !items.without_lot?
  end

  def all_licitation_process_classifications
    classifications.for_active_bidders.order(:bidder_id, :classification)
  end

  def destroy_all_licitation_process_classifications
    bidders.each(&:destroy_all_classifications)
  end

  def lots_with_items
    licitation_process_lots.select do |lot|
      lot.administrative_process_budget_allocation_items.present? && lot.bidder_proposals.present?
    end
  end

  def has_bidders_and_is_available_for_classification
    !bidders.empty? && available_for_licitation_process_classification?
  end

  def winning_bid
    all_licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON}
  end

  def edital_published?
    published_editals.any?
  end

  def ratification?
    licitation_process_ratifications.any?
  end

  def adjudication_date
    return unless first_ratification.present?

    first_ratification.adjudication_date
  end

  def ratification_date
    return unless first_ratification.present?

    first_ratification.ratification_date
  end

  def has_trading?
    trading.present?
  end

  def last_publication_date
    return if licitation_process_publications.empty?

    licitation_process_publications.current.publication_date
  end

  protected

  def available_for_licitation_process_classification?
    Modality.available_for_licitation_process_classification.include?(modality)
  end

  def last_licitation_number_of_self_year_and_modality
    self.class.
    where { |licitation_process|
      licitation_process.year.eq(year) & licitation_process.modality.eq(modality)
    }.
    maximum(:licitation_number).to_i
  end

  def assign_bidders_documents
    return unless allow_bidders?

    bidders.each do |bidder|
      bidder.assign_document_types
      bidder.save!
    end
  end

  def validate_type_of_calculation_by_judgment_form_kind(verificator = LicitationProcessTypesOfCalculationByJudgmentFormKind.new)
    return if type_of_calculation.nil? || judgment_form_kind.nil?

    unless verificator.correct_type_of_calculation?(judgment_form_kind, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_judgment_form_kind, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_type_of_calculation_by_object_type(verificator = LicitationProcessTypesOfCalculationByObjectType.new)
    return if type_of_calculation.nil? || object_type.nil?

    unless verificator.correct_type_of_calculation?(object_type, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_object_type, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_type_of_calculation_by_modality(verificator = LicitationProcessTypesOfCalculationByModality.new)
    return if type_of_calculation.nil? || modality.nil?

    unless verificator.correct_type_of_calculation?(modality, type_of_calculation)
      errors.add(:type_of_calculation, :not_permited_for_modality, :kind => LicitationProcessTypeOfCalculation.t(type_of_calculation))
    end
  end

  def validate_bidders_before_edital_publication
    if bidders.any? && !edital_published?
      errors.add(:base, :inclusion_of_bidders_before_edital_publication)
    end
  end

  def validate_envelope_opening_date
    return unless envelope_opening_date

    if envelope_opening_date && !last_publication_date
      errors.add :envelope_opening_date, :absence
      return false
    end

    LicitationProcessEnvelopeOpeningDate.new(self).valid?
  end

  def published_editals
    licitation_process_publications.edital
  end

  def validate_updates
    if changed_attributes.any?
      errors.add(:base, :cannot_be_edited)
    end
  end

  def first_ratification
    licitation_process_ratifications.first
  end

  def current_prefecture
    Prefecture.last
  end

  def allow_insert_past_processes?
    return unless current_prefecture

    current_prefecture.allow_insert_past_processes
  end
end

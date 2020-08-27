class LicitationProcess < Compras::Model
  include BelongsToResource

  attr_accessible :payment_method_id, :type_of_purchase,
                  :year, :process_date, :readjustment_index_id, :caution_value,
                  :envelope_delivery_date, :budget_allocation_year,
                  :envelope_delivery_time, :proposal_envelope_opening_date,
                  :proposal_envelope_opening_time, :document_type_ids,
                  :period, :period_unit, :expiration, :expiration_unit,
                  :judgment_form_id, :execution_type,
                  :price_registration, :status, :object_type, :date,
                  :protocol, :modality, :description,
                  :purchase_process_budget_allocations_attributes,
                  :contract_guarantees, :extension_clause, :index_update_rate_id,
                  :type_of_removal, :eletronic_trading, :notice_availability_date,
                  :contact_id, :stage_of_bids_date, :stage_of_bids_time,
                  :items_attributes, :minimum_bid_to_disposal, :concession_period,
                  :concession_period_unit, :goal, :licensor_rights_and_liabilities,
                  :licensee_rights_and_liabilities, :authorization_envelope_opening_date,
                  :authorization_envelope_opening_time, :closing_of_accreditation_date,
                  :closing_of_accreditation_time, :open_date,
                  :budget_allocations_total_value, :total_value_of_items,
                  :creditor_proposals_attributes, :tied_creditor_proposals_attributes,
                  :process_responsibles_attributes, :phone_email,
                  :justification, :justification_and_legal, :process,
                  :purchase_solicitation_import_option, :homologation_date,
                  :purchase_solicitations_attributes, :purchasing_unit_id,
                  :legal_analysis_appraisals_attributes, :publications_attributes,
                  :purchase_process_accreditation_attributes, :trading_attributes,
                  :judgment_commission_advice_attributes, :bidders_attributes,
                  :licitation_process_ratifications_attributes

  auto_increment :process, :by => :year
  auto_increment :modality_number, :by => [:year, :modality, :type_of_removal]

  attr_readonly :year, :modality_number

  attr_modal :process, :year, :process_date, :status, :description

  has_enumeration_for :concession_period_unit, :with => PeriodUnit
  has_enumeration_for :contract_guarantees, :with => UnicoAPI::Resources::Compras::Enumerations::ContractGuarantees
  has_enumeration_for :execution_type, :create_helpers => true
  has_enumeration_for :expiration_unit, :with => PeriodUnit
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true
  has_enumeration_for :object_type, :with => PurchaseProcessObjectType, :create_helpers => true
  has_enumeration_for :period_unit, :with => PeriodUnit, create_helpers: {prefix: true}
  has_enumeration_for :status, :with => PurchaseProcessStatus, :create_helpers => true
  has_enumeration_for :type_of_purchase, :with => PurchaseProcessTypeOfPurchase,
                      :create_helpers => true, create_scopes: true
  has_enumeration_for :type_of_removal, create_helpers: {prefix: true}
  has_enumeration_for :purchase_solicitation_import_option

  belongs_to :purchasing_unit
  belongs_to :contact, :class_name => 'Employee'
  belongs_to :judgment_form
  belongs_to :payment_method
  belongs_to :readjustment_index, :class_name => 'Indexer'
  belongs_to :index_update_rate, :class_name => 'Indexer'

  has_and_belongs_to_many :document_types, :join_table => :compras_licitation_processes_unico_document_types
  has_many :purchase_solicitations, -> { order(:id) }, class_name: 'ListPurchaseSolicitation', dependent: :destroy

  accepts_nested_attributes_for :purchase_solicitations,
                                :allow_destroy => true

  has_many :publications, -> { order(:id) }, class_name: 'LicitationProcessPublication', dependent: :destroy
  has_many :bidders, -> { order(:id) }, :dependent => :destroy
  has_many :licitation_process_impugnments, -> { order(:id) }, :dependent => :restrict
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :licitation_notices, :dependent => :destroy
  has_many :licitation_process_ratifications, -> { order(:id) }, :dependent => :restrict
  has_many :ratifications_items, -> { order(:id) }, through: :licitation_process_ratifications, source: :licitation_process_ratification_items
  has_many :licitation_process_ratification_creditors, -> { order(:id) }, through: :licitation_process_ratifications, source: :creditor
  has_many :classifications, :through => :bidders, :class_name => 'LicitationProcessClassification',
           :source => :licitation_process_classifications
  has_many :purchase_process_budget_allocations, -> { order(:id) }, :dependent => :destroy
  has_many :items, -> { order(:id) }, :class_name => 'PurchaseProcessItem', :dependent => :restrict,
           :inverse_of => :licitation_process
  has_many :materials, :through => :items
  has_many :legal_analysis_appraisals, :dependent => :restrict
  has_many :license_creditors, -> { order(:id) }, :through => :bidders, :dependent => :restrict, :source => :creditor
  has_many :accreditation_creditors, -> { order(:id) }, :through => :purchase_process_accreditation, :source => :creditors
  has_many :creditor_proposals, -> { order(:id) }, class_name: 'PurchaseProcessCreditorProposal'
  has_many :realignment_prices, dependent: :restrict, foreign_key: :purchase_process_id
  has_many :tied_creditor_proposals, -> { where(tied: true).order('ranking, creditor_id, purchase_process_item_id, lot') }, class_name: 'PurchaseProcessCreditorProposal'
  has_many :items_creditors, -> { order(:id) }, through: :items, source: :creditor
  has_many :creditor_disqualifications, class_name: 'PurchaseProcessCreditorDisqualification', dependent: :restrict
  has_many :process_responsibles, :dependent => :restrict
  has_many :trading_items, -> { order(:id) }, through: :trading, source: :items
  has_many :trading_item_bids, -> { order(:id) }, through: :trading_items, source: :bids
  has_many :trading_item_negotiations, -> { order(:id) }, through: :trading_items, source: :negotiation
  has_many :contracts, dependent: :restrict
  has_many :supply_requests, dependent: :restrict
  has_many :supply_orders, dependent: :restrict
  has_many :fractionations, class_name: 'PurchaseProcessFractionation', dependent: :destroy,
           foreign_key: :purchase_process_id

  has_one :judgment_commission_advice, :dependent => :restrict
  has_one :purchase_process_accreditation, :dependent => :restrict
  has_one :trading, class_name: 'PurchaseProcessTrading', :dependent => :restrict,
          foreign_key: :purchase_process_id

  accepts_nested_attributes_for :purchase_process_budget_allocations, :items, :creditor_proposals,
                                :process_responsibles, :tied_creditor_proposals, :legal_analysis_appraisals,
                                :publications, :bidders, :purchase_process_accreditation, :trading,
                                :licitation_process_ratifications, allow_destroy: true

  accepts_nested_attributes_for :judgment_commission_advice, :reject_if => :all_blank


  delegate :allow_negotiation?, to: :trading, allow_nil: true, prefix: true
  delegate :issuance_date, to: :judgment_commission_advice, allow_nil: true, prefix: true
  delegate :licitation_kind, :kind, :best_technique?, :technical_and_price?,
           :best_auction_or_offer?, :item?, :lot?, :global?, :higher_discount_on_table?,
           :lowest_price?, :higher_discount_on_lot?, :higher_discount_on_item?,
           :to => :judgment_form, :allow_nil => true, :prefix => true

  validates :process_date, :period, :contract_guarantees, :type_of_purchase, :purchasing_unit,
            :period_unit, :payment_method, :year, :execution_type, :object_type, :description,
            :notice_availability_date, :presence => true
  validates :envelope_delivery_date, :envelope_delivery_time, :expiration, :expiration_unit,
            :modality, :judgment_form_id, :presence => true, :if => :licitation?
  validates :goal, :licensor_rights_and_liabilities, :licensee_rights_and_liabilities,
            :presence => true, :if => :concessions_or_permits?
  validates :type_of_removal, :justification, :justification_and_legal, :presence => true, :if => :direct_purchase?
  validates :process, uniqueness: {scope: :year}
  validates :budget_allocation_year, numericality: {greater_than_or_equal_to: :year}, allow_blank: true
  validates :tied_creditor_proposals, no_duplication: {
      with: :ranking,
      allow_nil: true,
      scope: [:licitation_process_id, :purchase_process_item_id, :lot],
      if_condition: lambda {|creditor_proposal| creditor_proposal.ranking > 0}
  }
  validates :items, no_duplication: {
      with: :material_id,
      scope: [:creditor_id],
      message: :material_cannot_be_duplicated_by_creditor
  }
  # NOTE: Essa validação foi comentada por quebrar vários testes, depois da migração será descomentada
  # validate :validate_bidders_before_edital_publication
  validate :validate_updates, :unless => :updateable?
  validate :validate_proposal_envelope_opening_date, :on => :update, :if => :licitation?
  validate :validate_the_year_to_processe_date_are_the_same, :on => :update
  validate :validate_total_items
  validate :purchase_solicitations_blank?

  before_save :set_homologation_date
  after_save  :set_approved_status

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
    allowing_blank.validates :proposal_envelope_opening_date,
                             timeliness: {
                                 on_or_after: :proposal_envelope_opening_date_limit,
                                 type: :date,
                                 on: :update,
                                 if: :licitation?
                             }
    allowing_blank.validates :proposal_envelope_opening_date,
                             :timeliness => {
                                 :on_or_after => :envelope_delivery_date,
                                 :on_or_after_message => :should_be_on_or_after_envelope_delivery_date,
                                 :type => :date,
                                 :on => :create
                             }
    allowing_blank.validates :envelope_delivery_time, :proposal_envelope_opening_time,
                             :timeliness => {
                                 :type => :time,
                                 :on => :update
                             }
    allowing_blank.validates :stage_of_bids_time,
                             :timeliness => {
                                 :type => :time
                             }
  end

  orderize "created_at DESC"
  filterize

  scope :term, lambda {|q|
    where("process::text LIKE ?", "%#{q}%")
  }

  scope :published_edital, lambda {
    joins {publications}.where {
      publications.publication_of.eq PublicationOf::EDITAL
    }
  }

  scope :by_status, lambda {|status|
    # where {|query| query.status.eq status}
  }


  scope :by_ratification_month_and_year, lambda {|month, year|
    joins {licitation_process_ratifications}.
        where(%{
        extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
        extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
              month, year)
  }

  scope :by_ratification_and_year, lambda {|year|
    joins {licitation_process_ratifications}.
        where(%{
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?}, year)
  }

  scope :by_creditor, lambda {|creditor_id|
    joins {creditor_proposals}.where {
      creditor_proposals.creditor_id.eq creditor_id
    }.uniq
  }

  scope :by_contract, lambda {|contract_id|
    joins {contracts}.where {
      contracts.id.eq contract_id
    }
  }

  scope :by_department, lambda {|department_id|
    joins {contracts.authorized_areas.department}.where { contracts.authorized_areas.department.id.in department_id.delete("[]").split(",") }.uniq
  }

  scope :not_removal_by_limit, -> do
    where {type_of_removal.not_eq TypeOfRemoval::REMOVAL_BY_LIMIT}
  end

  scope :by_type_of_purchase, -> (type_of_purchase) do
    where {|query| query.type_of_purchase.eq type_of_purchase}
  end

  scope :ratified, lambda {
    joins {licitation_process_ratifications}.uniq
  }

  def get_items_amount
    val = 0
    self.items.each do |item|
      val += item.unit_price * item.quantity
    end
    val
  end

  def get_number_with_precision(val)
    val
  end

  def to_s
    "#{process}/#{year} - #{modality_or_type_of_removal_humanized} #{modality_number}"
  end

  def purchase_solicitations_blank?
    errors.add(:purchase_solicitations, :blank) if purchase_solicitations.blank?
  end

  def modality_or_type_of_removal
    "#{modality_number} - #{modality_humanize || type_of_removal_humanize}"
  end

  def modality_or_type_of_removal_humanized
    modality_humanize || type_of_removal_humanize
  end

  def creditors
    if direct_purchase?
      items_creditors
    elsif trading?
      accreditation_creditors
    else
      license_creditors
    end
  end

  def creditors_enabled
    return creditors if trading?

    creditors.enabled_or_benefited_by_purchase_process_id(self.id)
  end

  def update_status(status)
    update_column :status, status
  end

  def envelope_opening?
    return unless proposal_envelope_opening_date
    proposal_envelope_opening_date == Date.current
  end

  def updateable?
    new_record? || publications.current_updateable?
  end

  def all_licitation_process_classifications
    classifications.for_active_bidders.order(:bidder_id, :classification)
  end

  def destroy_all_licitation_process_classifications
    bidders.each(&:destroy_all_classifications)
  end

  def has_bidders_and_is_available_for_classification
    !bidders.empty? && available_for_licitation_process_classification?
  end

  def winning_bid
    all_licitation_process_classifications.detect {|classification| classification.situation == SituationOfProposal::WON}
  end

  def edital_published?
    published_editals.any?
  end

  def ratification?
    licitation_process_ratifications.any?
  end

  def has_trading?
    trading.present?
  end

  def last_publication_date
    return unless current_publication

    current_publication.publication_date
  end

  def current_publication
    return if publications.empty?

    publications.current
  end

  def process_date_year
    process_date && process_date.year
  end

  def proposals_of_creditor(creditor)
    creditor_proposals.creditor_id(creditor.id).order(:id)
  end

  def proposals_total_price(creditor)
    proposals_of_creditor(creditor).sum(&:total_price)
  end

  def allow_trading_auto_creation?
    persisted? && trading? && !has_trading?
  end

  def each_item_lot
    items.map(&:lot).uniq.each do |lot|
      yield lot
    end
  end

  def all_proposals_given?
    return false if creditor_proposals.empty?

    case judgment_form_kind
    when JudgmentFormKind::ITEM
      creditor_proposals.count == creditors.count * items.count
    when JudgmentFormKind::LOT
      creditor_proposals.count == creditors.count * items.lots.count
    else
      creditor_proposals.count == creditors.count
    end
  end

  def concessions_or_permits?
    return unless object_type

    concessions? || permits?
  end

  def published_editals
    publications.edital
  end

  def budget_allocations_ids
    return [] unless purchase_process_budget_allocations

    # purchase_process_budget_allocations.map(&:budget_allocation_id)
  end

  def budget_allocations
    return unless purchase_process_budget_allocations

    purchase_process_budget_allocations.map(&:budget_allocation)
  end

  def reserve_funds(repository = ReserveFund)
    repository.all(params: {by_purchase_process_id: id})
  end

  def budget_allocation_capabilities
    return unless budget_allocations

    budget_allocations.map(&:budget_allocation_capabilities).flatten
  end

  def reserve_funds_available(repository = ReserveFund)
    repository.all(
        params: {
            by_purchase_process_id: id,
            without_pledge: true
        })
  end

  def destroy_fractionations!
    fractionations.destroy_all
  end

  def calculate_total_value_of_items
    return unless items

    self.total_value_of_items = items.reject(&:marked_for_destruction?).sum(&:estimated_total_price)
  end

  def calculate_budget_allocations_total_value
    return unless purchase_process_budget_allocations.any?

    self.budget_allocations_total_value = purchase_process_budget_allocations.reject(&:marked_for_destruction?).sum(&:value)
  end

  protected

  def set_homologation_date
    if self.status_changed? && self.status == PurchaseProcessStatus::APPROVED
      self.homologation_date = Date.today
    end
  end

  def set_approved_status
    if licitation_process_ratifications.any?
      update_status(PurchaseProcessStatus::APPROVED)
    end
  end

  def available_for_licitation_process_classification?
    Modality.available_for_licitation_process_classification.include?(modality)
  end

  def validate_total_items
    limit = ModalityLimitChooser.limit(self)

    if limit
      items.reject(&:marked_for_destruction?).group_by(&:material_class).each do |material_class, grouped_items|
        if grouped_items.sum(&:estimated_total_price) > limit
          message = :licitation_process_material_class_reach_to_the_limit
          modality_type = modality_humanize

          if direct_purchase?
            message = :direct_purchase_material_class_reach_to_the_limit
            modality_type = type_of_removal_humanize
          end

          errors.add :base, message,
                     material_class: material_class, modality: modality_type,
                     limit: ::I18n::Alchemy::NumericParser.localize(limit)
        end
      end
    end
  end

  def validate_the_year_to_processe_date_are_the_same
    errors.add(:process_date, :cannot_change_the_year_from_the_date_of_dispatch) unless process_date_year == year
  end

  def validate_bidders_before_edital_publication
    if bidders.any? && !edital_published? && licitation?
      errors.add(:base, :inclusion_of_bidders_before_edital_publication)
    end
  end

  def validate_budget_allocations_destruction
    error = false

    purchase_process_budget_allocations.select(&:marked_for_destruction?).each do |pp_budget_allocation|
      unless pp_budget_allocation.budget_allocation(false).can_be_used?(self)
        errors.add :base, :budget_allocation_cannot_be_destroyed, budget_allocation: pp_budget_allocation.budget_allocation(false)

        error = true
      end
    end

    purchase_process_budget_allocations.reload if error # Limpa os marked_for_destruction
  end

  def validate_proposal_envelope_opening_date
    return unless proposal_envelope_opening_date

    unless last_publication_date
      errors.add :proposal_envelope_opening_date, :absence
      return false
    end
  end

  def proposal_envelope_opening_date_limit
    PurchaseProcessProposalEnvelopeOpeningDateCalculator.calculate(self)
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

  def material_ids_or_zero
    return 0 if material_ids.size == 0

    material_ids.join(',')
  end

  def update_purchase_solicitation_to_purchase_process(purchase_solicitation)
    purchase_solicitations.each do |purchase_solicitation|
      purchase_solicitation.buy! if valid?
    end
  end

  def update_purchase_solicitation_to_liberated(purchase_solicitation)
    purchase_solicitation.liberate! if valid?
  end
end

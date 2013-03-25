class LicitationProcess < Compras::Model
  attr_accessible :capability_id, :payment_method_id, :type_of_purchase,
                  :year, :process_date,:readjustment_index_id, :caution_value,
                  :envelope_delivery_date,
                  :envelope_delivery_time, :proposal_envelope_opening_date,
                  :proposal_envelope_opening_time, :document_type_ids,
                  :period, :period_unit, :expiration, :expiration_unit,
                  :judgment_form_id, :execution_type,
                  :disqualify_by_documentation_problem, :disqualify_by_maximum_value,
                  :consider_law_of_proposals, :price_registration, :status,
                  :responsible_id, :purchase_solicitation_id, :object_type,
                  :date, :protocol, :item, :purchase_solicitation_item_group_id,
                  :summarized_object, :modality, :description, :pledge_type,
                  :administrative_process_budget_allocations_attributes,
                  :contract_guarantees, :extension_clause, :index_update_rate_id,
                  :type_of_removal, :is_trading, :notice_availability_date,
                  :contact_id, :stage_of_bids_date, :items_attributes,
                  :minimum_bid_to_disposal, :concession_period,
                  :concession_period_unit, :goal, :licensor_rights_and_liabilities,
                  :licensee_rights_and_liabilities, :authorization_envelope_opening_date,
                  :authorization_envelope_opening_time, :closing_of_accreditation_date,
                  :closing_of_accreditation_time

  auto_increment :process, :by => :year
  auto_increment :modality_number, :by => [:year, :modality, :type_of_removal]

  attr_readonly :process, :year, :licitation_number, :modality_number

  attr_modal :process, :year, :process_date, :licitation_number

  has_enumeration_for :concession_period_unit, :with => PeriodUnit
  has_enumeration_for :contract_guarantees
  has_enumeration_for :execution_type, :create_helpers => true
  has_enumeration_for :expiration_unit, :with => PeriodUnit
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true
  has_enumeration_for :object_type, :with => LicitationProcessObjectType, :create_helpers => true
  has_enumeration_for :period_unit, :with => PeriodUnit
  has_enumeration_for :pledge_type
  has_enumeration_for :status, :with => LicitationProcessStatus, :create_helpers => true
  has_enumeration_for :type_of_purchase, :with => LicitationProcessTypeOfPurchase, :create_helpers => true
  has_enumeration_for :type_of_removal

  belongs_to :capability
  belongs_to :contact, :class_name => 'Employee'
  belongs_to :judgment_form
  belongs_to :payment_method
  belongs_to :purchase_solicitation
  belongs_to :purchase_solicitation_item_group
  belongs_to :readjustment_index, :class_name => 'Indexer'
  belongs_to :index_update_rate, :class_name => 'Indexer'
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
  has_many :budget_allocations, :through => :administrative_process_budget_allocations
  has_many :items, :class_name => 'AdministrativeProcessBudgetAllocationItem', :dependent => :restrict, :order => :id
  has_many :materials, :through => :items
  has_many :purchase_solicitation_items,
           :class_name => 'PurchaseSolicitationBudgetAllocationItem',
           :finder_sql => Proc.new { purchase_solicitation_items_finder_sql },
           :inverse_of => :fulfiller

  has_one :trading, :dependent => :restrict

  accepts_nested_attributes_for :administrative_process_budget_allocations, :items, :allow_destroy => true

  delegate :kind, :best_technique?, :technical_and_price?,
           :to => :judgment_form, :allow_nil => true, :prefix => true
  delegate :licitation_kind, :to => :judgment_form, :allow_nil => true, :prefix => true

  validates :process_date, :capability, :period, :contract_guarantees, :type_of_purchase,
            :period_unit, :expiration, :expiration_unit, :payment_method,
            :envelope_delivery_time, :year, :envelope_delivery_date,
            :pledge_type, :execution_type, :object_type,
            :judgment_form_id, :responsible, :description, :notice_availability_date,
            :presence => true
  validates :modality, :presence => true, :if => :licitation?
  validates :goal, :licensor_rights_and_liabilities, :licensee_rights_and_liabilities,
            :presence => true, :if => :concessions_and_permits?
  validates :type_of_removal, :presence => true, :if => :direct_purchase?
  validate :validate_bidders_before_edital_publication
  validate :validate_updates, :unless => :updatable?
  validate :validate_proposal_envelope_opening_date, :on => :update

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
    "#{process}/#{year} - #{modality_humanize} #{modality_number}"
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
    return unless proposal_envelope_opening_date
    proposal_envelope_opening_date == Date.current
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

  def has_trading?
    trading.present?
  end

  def last_publication_date
    return if licitation_process_publications.empty?

    licitation_process_publications.current.publication_date
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

  def attend_purchase_solicitation_items
    purchase_solicitation_items.attend!
  end

  def partially_fulfilled_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.partially_fulfilled!
    end
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

  def validate_bidders_before_edital_publication
    if bidders.any? && !edital_published?
      errors.add(:base, :inclusion_of_bidders_before_edital_publication)
    end
  end

  def validate_proposal_envelope_opening_date
    return unless proposal_envelope_opening_date

    if proposal_envelope_opening_date && !last_publication_date
      errors.add :proposal_envelope_opening_date, :absence
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

  def material_ids_or_zero
    return 0 if material_ids.size == 0

    material_ids.join(',')
  end

  def purchase_solicitation_items_finder_sql
    %Q{
      SELECT "compras_purchase_solicitation_budget_allocation_items".* FROM "compras_licitation_processes"
        INNER JOIN "compras_purchase_solicitations" ON
          "compras_purchase_solicitations"."id" = "compras_licitation_processes"."purchase_solicitation_id"
        INNER JOIN "compras_purchase_solicitation_budget_allocations" ON
          "compras_purchase_solicitation_budget_allocations"."purchase_solicitation_id" = "compras_purchase_solicitations"."id"
        INNER JOIN "compras_purchase_solicitation_budget_allocation_items" ON
          "compras_purchase_solicitation_budget_allocation_items"."purchase_solicitation_budget_allocation_id" = "compras_purchase_solicitation_budget_allocations"."id"
        WHERE (("compras_licitation_processes"."id" = #{id} AND
          "compras_purchase_solicitation_budget_allocation_items"."material_id" IN (#{material_ids_or_zero})))
    }
  end
end

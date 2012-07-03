class LicitationProcessBidder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :protocol, :protocol_date, :status
  attr_accessible :receipt_date, :invited, :documents_attributes, :proposals_attributes
  attr_accessible :technical_score, :person_ids, :licitation_process_id

  has_enumeration_for :status, :with => LicitationProcessBidderStatus

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :documents, :class_name => :LicitationProcessBidderDocument, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :documents
  has_many :proposals, :class_name => :LicitationProcessBidderProposal, :dependent => :destroy, :order => :id
  has_many :accredited_representatives, :dependent => :destroy
  has_many :people, :through => :accredited_representatives

  delegate :document_type_ids, :process_date, :to => :licitation_process, :prefix => true
  delegate :administrative_process, :envelope_opening?, :to => :licitation_process, :allow_nil => true
  delegate :invited?, :to => :administrative_process, :prefix => true
  delegate :licitation_process_lots, :to => :licitation_process
  delegate :administrative_process_budget_allocation_items, :to => :licitation_process_lots
  delegate :material, :to => :administrative_process_budget_allocation_items
  delegate :items, :allow_bidders?, :to => :licitation_process, :allow_nil => true

  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :proposals, :allow_destroy => true

  validates :creditor, :presence => true
  validates :protocol, :protocol_date, :receipt_date, :presence => true, :if => :invited
  validates :creditor_id, :uniqueness => { :scope => :licitation_process_id, :allow_blank => true }
  validates :technical_score, :presence => true, :if => :validate_technical_score?
  validate :validate_licitaton_process_envelope_opening_date

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :protocol_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create,
        :if => :invited
      }
    allowing_blank.validates :receipt_date,
      :timeliness => {
        :on_or_after => :protocol_date,
        :on_or_after_message => :should_be_on_or_after_protocol_date,
        :type => :date,
        :on => :create,
        :if => :invited
      }
  end

  before_save :clear_invited_data, :set_default_values

  orderize :id
  filterize

  def proposals_by_lot(lot)
    proposals.select { |proposal| proposal.licitation_process_lot == lot }
  end

  def filled_documents?
    return false if documents.empty?

    documents.each do |document|
      return false if document.document_number.blank? ||
                      document.emission_date.blank? ||
                      document.validity.blank?
    end
    true
  end

  def to_s
    creditor.to_s
  end

  def assign_document_types
    self.document_type_ids = licitation_process_document_type_ids
  end

  def build_documents
    licitation_process_document_type_ids.each do |document_type_id|
      documents.build(:document_type_id => document_type_id)
    end
  end

  def can_update_proposals?
    licitation_process.filled_lots? || licitation_process_lots.empty?
  end

  def proposal_total_value
    total = self.class.joins { proposals.administrative_process_budget_allocation_item }.
      where { |bidder| bidder.id.eq id }.
      select { sum(proposals.administrative_process_budget_allocation_item.quantity * proposals.unit_price).as(proposal_total) }.first.proposal_total

    BigDecimal.new(total || 0)
  end

  def proposal_total_value_by_lot(lot_id = nil)
    return 0 unless lot_id

    total = self.class.joins { proposals.administrative_process_budget_allocation_item.licitation_process_lot }.
      where { |bidder| (bidder.id.eq id) & (bidder.proposals.administrative_process_budget_allocation_item.licitation_process_lot.id.eq lot_id) }.
      select { sum(proposals.administrative_process_budget_allocation_item.quantity * proposals.unit_price).as(proposal_total) }.first.proposal_total

    BigDecimal.new(total || 0)
  end

  protected

  def validate_licitaton_process_envelope_opening_date
    return if licitation_process.nil?

    unless allow_bidders?
      errors.add(:licitation_process, :must_be_the_licitation_process_envelope_opening_date)
    end
  end

  def clear_invited_data
    unless invited?
      self.protocol = nil
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end

  def set_default_values
    proposals.each do |proposal|
      proposal.situation = nil
      proposal.classification = nil
      proposal.unit_price = 0 unless proposal.unit_price
    end
  end

  def validate_technical_score?
    return unless administrative_process.present?

    administrative_process.judgment_form_best_technique? || administrative_process.judgment_form_technical_and_price?
  end
end

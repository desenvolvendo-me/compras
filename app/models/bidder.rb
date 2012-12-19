class Bidder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :protocol, :protocol_date,
                  :receipt_date, :invited, :documents_attributes, :proposals_attributes,
                  :technical_score, :person_ids, :licitation_process_id, :status,
                  :will_submit_new_proposal_when_draw

  attr_modal :licitation_process_id, :creditor_id, :protocol, :protocol_date, :status

  has_enumeration_for :status, :create_helpers => true

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :documents, :class_name => :BidderDocument, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :documents
  has_many :proposals, :class_name => :BidderProposal, :dependent => :destroy, :order => :id
  has_many :accredited_representatives, :dependent => :destroy
  has_many :people, :through => :accredited_representatives
  has_many :licitation_process_classifications, :dependent => :destroy
  has_many :licitation_process_classifications_by_classifiable, :as => :classifiable, :dependent => :destroy, :class_name => 'LicitationProcessClassification'
  has_many :trading_item_bids, :dependent => :restrict

  delegate :document_type_ids, :process_date, :ratification?,
           :to => :licitation_process, :prefix => true, :allow_nil => true
  delegate :administrative_process, :envelope_opening?, :items, :allow_bidders?,
           :consider_law_of_proposals, :licitation_process_lots,
           :to => :licitation_process, :allow_nil => true
  delegate :invited?, :to => :administrative_process, :prefix => true
  delegate :administrative_process_budget_allocation_items, :to => :licitation_process_lots
  delegate :material, :to => :administrative_process_budget_allocation_items
  delegate :benefited, :to => :creditor, :allow_nil => true

  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :proposals, :allow_destroy => true

  validates :creditor, :presence => true
  validates :protocol, :protocol_date, :receipt_date, :presence => true, :if => :invited
  validates :creditor_id, :uniqueness => { :scope => :licitation_process_id, :allow_blank => true }
  validates :technical_score, :presence => true, :if => :validate_technical_score?
  validate :validate_licitation_process_envelope_opening_date, :on => :create
  validate :block_licitation_process_with_ratification

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

  def self.destroy_all_classifications
    classifications.destroy_all
  end

  def self.with_negociation_proposal_for(trading_item_id)
    enabled.
    joins { trading_item_bids }.
    where {
      trading_item_bids.stage.eq(TradingItemBidStage::NEGOTIATION) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }
  end

  def self.eligible_for_negociation_stage(value)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.stage.eq(TradingItemBidStage::ROUND_OF_BIDS) &
      trading_item_bids.amount.lteq(value)
    }
  end

  def self.classifications
    LicitationProcessClassification.joins { bidder }.readonly(false).
      where do |classification|
        classification.bidder_id.in(pluck(:id)) &
        (classification.bidder.status.not_eq(Status::INACTIVE) |
         classification.bidder.status.eq(nil))
      end
  end

  def self.with_no_proposal_for_trading_item(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.not_eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }.uniq
  end

  def self.with_proposal_for_trading_item(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }.uniq
  end

  def self.with_proposal_for_trading_item_round(round)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.round.eq(round)
    }
  end

  def self.with_proposal_for_proposal_stage_with_amount_lower_than_limit(item)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.stage.eq(TradingItemBidStage::PROPOSALS) &
      trading_item_bids.amount.lteq(item.value_limit_to_participate_in_bids) &
      trading_item_bids.trading_item_id.eq(item.id)
    }
  end

  def self.enabled
    where { disabled.eq(false) }
  end

  def self.disabled
    where { disabled.eq(true) }
  end

  def self.at_bid_round(round, trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.round.eq(round) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }
  end

  def self.at_trading_item_stage(trading_item, stage)
    joins { trading_item_bids }.
    where {
      trading_item_bids.trading_item_id.eq(trading_item_id) &
      trading_item_bids.stage.eq(stage)
    }
  end

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

  def expired_documents?
    documents.each do |document|
      return true if document.expired?
    end

    false
  end

  def has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
    proposals.select(&:unit_price_greater_than_budget_allocation_item_unit_price?).any?
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

    BigDecimal(total || 0)
  end

  def proposal_total_value_by_lot(lot_id = nil)
    return BigDecimal(0) unless lot_id

    total = self.class.joins { proposals.administrative_process_budget_allocation_item.licitation_process_lot }.
      where { |bidder| (bidder.id.eq id) & (bidder.proposals.administrative_process_budget_allocation_item.licitation_process_lot.id.eq lot_id) }.
      select { sum(proposals.administrative_process_budget_allocation_item.quantity * proposals.unit_price).as(proposal_total) }.first.proposal_total

    BigDecimal(total || 0)
  end

  def has_item_with_unit_price_equals_zero(lot = nil)
    proposals.any_without_unit_price?(lot)
  end

  def total_price
    return BigDecimal(0) if proposals.empty?

    proposals.sum(&:total_price)
  end

  def benefited_by_law_of_proposals?
    consider_law_of_proposals && benefited
  end

  def inactivate!
    update_column(:status, Status::INACTIVE)
  end

  def activate!
    update_column(:status, Status::ACTIVE)
  end

  def has_documentation_problem?
    !filled_documents? || expired_documents?
  end

  def lower_trading_item_bid_amount(trading_item)
    lower_trading_item_bid(trading_item).try(:amount) || BigDecimal(0)
  end

  def trading_item_classification_percent(trading_item)
    return unless lower_trading_item_bid(trading_item)

    if trading_item.lowest_proposal_amount == lower_trading_item_bid_amount(trading_item)
      BigDecimal(0)
    else
      classification_percent(trading_item.lowest_proposal_amount, lower_trading_item_bid_amount(trading_item))
    end
  end

  def disable!(reference_date = Date.current)
    update_attribute :disabled, true
    update_attribute :disabled_at, reference_date
  end

  def lower_trading_item_bid(trading_item)
    trading_item_bids.for_trading_item(trading_item.id).with_proposal.last
  end

  protected

  def block_licitation_process_with_ratification
    return unless licitation_process.present?

    if licitation_process_ratification?
      errors.add(:base, :cannot_be_changed_when_the_licitation_process_has_a_ratification, :licitation_process => licitation_process)
    end
  end

  def classification_percent(first_place_amount, current_amount)
    ((current_amount - first_place_amount) / first_place_amount) * BigDecimal(100)
  end

  def validate_licitation_process_envelope_opening_date
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

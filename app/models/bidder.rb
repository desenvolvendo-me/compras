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
  has_many :licitation_process_ratifications, :dependent => :restrict
  has_many :trading_item_closings, :dependent => :restrict

  has_one :disqualification, :dependent => :destroy, :class_name => 'BidderDisqualification'

  delegate :document_type_ids, :process_date, :ratification?, :trading?,
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

  scope :exclude_ids, lambda { |ids|  where { id.not_in(ids) } }

  def self.benefited
    joins { creditor.creditable(Person).personable(Company).company_size.extended_company_size }.
    where { 'compras_extended_company_sizes.benefited = true' }
  end

  def self.with_negotiation_proposal_for(trading_item_id)
    enabled.
    joins { trading_item_bids }.
    where {
      trading_item_bids.stage.eq(TradingItemBidStage::NEGOTIATION) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }
  end

  def self.eligible_for_negotiation_stage(value)
    enabled.
    joins { trading_item_bids.trading_item }.
    where {
      (trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
       trading_item_bids.stage.eq(TradingItemBidStage::ROUND_OF_BIDS) &
       trading_item_bids.amount.lteq(value)) |

      (trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
       trading_item_bids.stage.eq(TradingItemBidStage::PROPOSALS) &
       trading_item_bids.amount.gt(value) &
       trading_item_bids.trading_item.proposals_activated_at.not_eq(nil))
    }.uniq
  end

  def self.won_calculation
    joins { licitation_process_classifications }.
    where { licitation_process_classifications.situation.eq(SituationOfProposal::WON) }
  end

  def self.without_ratification
    joins { licitation_process_ratifications.outer }.
    where { licitation_process_ratifications.id.eq(nil) }
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

  def self.with_proposal_for_trading_item_at_stage_of_round_of_bids(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.stage.eq(TradingItemBidStage::ROUND_OF_BIDS) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }.uniq
  end

  def self.with_proposal_for_trading_item_at_stage_of_negotiation(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.stage.eq(TradingItemBidStage::NEGOTIATION) &
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

  def self.under_limit_value(trading_item_id, limit_value)
    joins { trading_item_bids }.
    where {
      trading_item_bids.status.eq(TradingItemBidStatus::WITH_PROPOSAL) &
      trading_item_bids.amount.lteq(limit_value) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }
  end

  def self.enabled
    joins { disqualification.outer }.
    where { disqualification.id.eq(nil) }
  end

  def self.disabled
    joins { disqualification }
  end

  def self.at_bid_round(round, trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.round.eq(round) &
      trading_item_bids.trading_item_id.eq(trading_item_id)
    }
  end

  def self.at_round_of_bids(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.trading_item_id.eq(trading_item_id) &
      trading_item_bids.stage.eq(TradingItemBidStage::ROUND_OF_BIDS)
    }
  end

  def self.at_proposals(trading_item_id)
    joins { trading_item_bids }.
    where {
      trading_item_bids.trading_item_id.eq(trading_item_id) &
      trading_item_bids.stage.eq(TradingItemBidStage::PROPOSALS)
    }
  end

  def self.ordered_by_trading_item_bid_amount(trading_item_id)
    joins { trading_item_bids.outer }.
    where { |bidder| bidder.trading_item_bids.trading_item_id.eq(trading_item_id) }.
    group { id }.
    reorder { [min(trading_item_bids.amount), id] }.
    select('compras_bidders.*, min(compras_trading_item_bids.amount)')
  end

  def destroy_all_classifications
    licitation_process_classifications.destroy_all
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

  def lower_trading_item_bid_amount_at_stage_of_proposals(trading_item)
    lower_trading_item_bid_at_stage_of_proposals(trading_item).try(:amount) || BigDecimal(0)
  end

  def lower_trading_item_bid_amount_at_stage_of_round_of_bids(trading_item)
    lower_trading_item_bid_at_stage_of_round_of_bids(trading_item).try(:amount) || BigDecimal(0)
  end

  def lower_trading_item_bid_amount_at_stage_of_negotiation(trading_item)
    lower_trading_item_bid_at_stage_of_negotiation(trading_item).try(:amount) || BigDecimal(0)
  end

  def trading_item_classification_percent(trading_item)
    return unless lower_trading_item_bid(trading_item)

    if trading_item.lowest_proposal_amount == lower_trading_item_bid_amount(trading_item)
      BigDecimal(0)
    else
      classification_percent(trading_item.lowest_proposal_amount, lower_trading_item_bid_amount(trading_item))
    end
  end

  def trading_item_proposal_percent(trading_item)
    return unless lower_trading_item_bid_at_stage_of_proposals(trading_item)

    if trading_item.lowest_proposal_at_stage_of_proposals_amount == lower_trading_item_bid_at_stage_of_proposals_amount(trading_item)
      BigDecimal(0)
    else
      classification_percent(trading_item.lowest_proposal_at_stage_of_proposals_amount, lower_trading_item_bid_at_stage_of_proposals_amount(trading_item))
    end
  end

  def lower_trading_item_bid(trading_item)
    trading_item_bids.for_trading_item(trading_item.id).with_proposal.last
  end

  def last_amount_valid_for_trading_item(item)
    trading_item_bids.for_trading_item(item.id).last_valid_proposal.amount
  end

  def last_amount_valid_for_trading_item_at_stage_of_round_of_bids(item)
    trading_item_bids.at_stage_of_round_of_bids.for_trading_item(item.id).last_valid_proposal.try(:amount) || BigDecimal(0)
  end

  def last_amount_valid_for_trading_item_at_stage_of_negotiation(item)
    trading_item_bids.at_stage_of_negotiation.for_trading_item(item.id).last_valid_proposal.try(:amount) || BigDecimal(0)
  end

  def last_bid(item)
    trading_item_bids.for_trading_item(item.id).last
  end

  def disabled
    disqualification.present?
  end

  def can_be_disabled?(trading_item)
    (trading_item.bidder_with_lowest_proposal == self) && !benefited && negotiation_for(trading_item.id).empty?
  end

  def selected_for_trading_item?(trading_item)
    trading_item.selected_bidders_at_proposals.include?(self)
  end

  protected

  def negotiation_for(trading_item_id)
    trading_item_bids.at_stage_of_negotiation.for_trading_item(trading_item_id)
  end

  def lower_trading_item_bid_at_stage_of_proposals_amount(trading_item)
    lower_trading_item_bid_at_stage_of_proposals(trading_item).try(:amount) || BigDecimal(0)
  end

  def lower_trading_item_bid_at_stage_of_proposals(trading_item)
    trading_item_bids.at_stage_of_proposals.for_trading_item(trading_item.id).with_proposal.last
  end

  def lower_trading_item_bid_at_stage_of_round_of_bids(trading_item)
    trading_item_bids.at_stage_of_round_of_bids.for_trading_item(trading_item.id).with_proposal.last
  end

  def lower_trading_item_bid_at_stage_of_negotiation(trading_item)
    trading_item_bids.at_stage_of_negotiation.for_trading_item(trading_item.id).with_proposal.last
  end

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

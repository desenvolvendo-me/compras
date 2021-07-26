class PurchaseProcessCreditorDisqualification < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :disqualification_date,
                  :reason, :kind, :proposal_item_ids

  attr_accessor :proposal_item_ids

  has_enumeration_for :kind, :with => PurchaseProcessCreditorDisqualificationKind, create_helpers: true

  belongs_to :licitation_process
  belongs_to :creditor

  has_one :judgment_form, through: :licitation_process

  delegate :global?, to: :judgment_form, allow_nil: true, prefix: true

  validates :licitation_process, :creditor, :disqualification_date, :reason, :kind, presence: true
  validate :kind_should_be_total, if: :judgment_form_global?

  after_save :disqualify_proposal_items

  scope :by_creditor_id, lambda { |creditor| where(creditor_id: creditor) }
  scope :by_licitation_process_id, lambda { |licitation_process| where(licitation_process_id: licitation_process) }
  scope :by_licitation_process_and_creditor, lambda { |licitation_process, creditor|
    by_licitation_process_id(licitation_process).
    by_creditor_id(creditor)
  }

  def self.find_or_initialize(licitation_process, creditor)
    by_licitation_process_and_creditor(licitation_process.id, creditor.id).first_or_initialize
  end

  def self.disqualification_status(licitation_process_id, creditor_id)
    disqualification = self.by_licitation_process_and_creditor(licitation_process_id, creditor_id).first

    return :not if (disqualification.nil? || disqualification.all_items_qualified?)
    return :fully if disqualification.all_items_disqualified?
    :partially
  end

  def proposal_items
    licitation_process.proposals_of_creditor(creditor)
  end

  def all_items_disqualified?
    proposal_items.all?(&:disqualified?)
  end

  def all_items_qualified?
    proposal_items.all?(&:qualified?)
  end

  private

  def disqualify_proposal_items
    proposal_items.each do |item|
      item.qualify!
      item.disqualify! if disqualify_item? item
      PurchaseProcessCreditorProposalRanking.rank! item
    end
  end

  def disqualify_item?(item)
    return true if (total? || proposal_item_ids.include?(item.id.to_s))
  end

  def kind_should_be_total
    errors.add(:kind, :should_be_total) unless total?
  end
end

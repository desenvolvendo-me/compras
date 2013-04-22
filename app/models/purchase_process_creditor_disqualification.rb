class PurchaseProcessCreditorDisqualification < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :disqualification_date,
                  :reason, :kind, :proposal_item_ids

  attr_accessor :proposal_item_ids

  has_enumeration_for :kind, :with => PurchaseProcessCreditorDisqualificationKind

  belongs_to :licitation_process
  belongs_to :creditor

  validates :licitation_process, :creditor, :disqualification_date,
            :reason, :kind, presence: true

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

  def proposal_items
    licitation_process.proposals_of_creditor(creditor)
  end

  private

  def disqualify_proposal_items
    proposal_items.each do |item|
      item.qualify!
      item.disqualify! if disqualify_item? item
    end
  end

  def disqualify_item?(item)
    return true if kind == PurchaseProcessCreditorDisqualificationKind::TOTAL
    return true if proposal_item_ids.include? item.id.to_s
  end
end

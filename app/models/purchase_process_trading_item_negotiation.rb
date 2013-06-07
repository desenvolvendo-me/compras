class PurchaseProcessTradingItemNegotiation < Compras::Model
  attr_accessible :purchase_process_trading_item_id,
    :purchase_process_accreditation_creditor_id, :amount

  belongs_to :item, class_name: 'PurchaseProcessTradingItem',
    foreign_key: :purchase_process_trading_item_id
  belongs_to :accreditation_creditor, class_name: 'PurchaseProcessAccreditationCreditor',
    foreign_key: :purchase_process_accreditation_creditor_id

  has_one :creditor, through: :accreditation_creditor

  delegate :lowest_bid_or_proposal_amount, to: :item, allow_nil: true

  validates :item, :purchase_process_accreditation_creditor_id, :amount, presence: true
  validate :minimum_amount

  private

  def minimum_amount(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless lowest_bid_or_proposal_amount

    if amount >= lowest_bid_or_proposal_amount
      errors.add :amount, :less_than, count: numeric_parser.localize(lowest_bid_or_proposal_amount)
    end
  end
end

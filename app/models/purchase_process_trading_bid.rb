class PurchaseProcessTradingBid < Compras::Model
  attr_accessible :amount, as: :trading_user
  attr_accessible :purchase_process_accreditation_creditor_id, :number,
                  :purchase_process_item_id, :purchase_process_trading_id,
                  :round, :disqualification_reason, :lot, :amount, :status

  has_enumeration_for :status, with: TradingItemBidStatus, create_helpers: true,
                      create_scopes: true

  belongs_to :accreditation_creditor, class_name: 'PurchaseProcessAccreditationCreditor',
             foreign_key: :purchase_process_accreditation_creditor_id
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id
  belongs_to :trading, class_name: 'PurchaseProcessTrading', foreign_key: :purchase_process_trading_id

  has_one :creditor, through: :accreditation_creditor

  delegate :name, to: :creditor, allow_nil: true, prefix: true
  delegate :lowest_trading_bid, to: :item, allow_nil: true

  validates :accreditation_creditor, :trading, :amount, :status, :round,  presence: true
  validates :amount, numericality: { greater_than: 0, if: :with_proposal? }
  validate  :validate_minimum_amount, on: :update, if: :with_proposal?

  scope :by_item_id, lambda { |item_id|
    where { |bid| bid.purchase_process_item_id.eq(item_id) }
  }

  scope :by_round, lambda { |round|
    where { |bid| bid.round.eq(round) }
  }

  scope :not_without_proposal, lambda {
    where { status.not_eq(TradingItemBidStatus::WITHOUT_PROPOSAL) }
  }

  def percent
    return unless amount > BigDecimal("0")

    if lowest_trading_bid_amount && amount != lowest_trading_bid_amount
      ( (amount - lowest_trading_bid_amount) / lowest_trading_bid_amount * BigDecimal('100') ).round(2)
    else
      BigDecimal("0")
    end
  end

  private

  def validate_minimum_amount
    return unless lowest_trading_bid_amount.present?

    if amount >= lowest_trading_bid_amount
      errors.add(:amount, :less_than, :count => I18n::Alchemy::NumericParser.localize(lowest_trading_bid_amount))
    end
  end

  def lowest_trading_bid_amount
    if lowest_trading_bid
      lowest_trading_bid.amount
    else
      item_trading_lowest_proposal_unit_price
    end
  end

  def item_trading_lowest_proposal_unit_price
    return unless item.trading_lowest_proposal

    item.trading_lowest_proposal.unit_price
  end
end

class PurchaseProcessTradingItemBid < Compras::Model
  attr_accessible :amount, as: :trading_user
  attr_accessible :purchase_process_accreditation_creditor_id, :number,
                  :item_id, :purchase_process_trading_id,
                  :round, :disqualification_reason, :amount, :status

  has_enumeration_for :status, with: TradingItemBidStatus, create_helpers: true,
                      create_scopes: true

  belongs_to :accreditation_creditor, class_name: 'PurchaseProcessAccreditationCreditor',
             foreign_key: :purchase_process_accreditation_creditor_id
  belongs_to :item, class_name: 'PurchaseProcessTradingItem'

  has_one :trading, through: :item
  has_one :creditor, through: :accreditation_creditor

  delegate :name, to: :creditor, allow_nil: true, prefix: true
  delegate :lowest_bid, :reduction_rate_value, :reduction_rate_percent, :lowest_bid_or_proposal_amount,
           :lowest_bid_or_proposal_accreditation_creditor, :lot, :lot?, :item?, to: :item, allow_nil: true
  delegate :item_lot, to: :item, allow_nil: true, prefix: true
  delegate :benefited?, to: :accreditation_creditor, allow_nil: true, prefix: true

  validates :purchase_process_accreditation_creditor_id, :item, :amount, :status, :round,  presence: true
  validates :amount, numericality: { greater_than: 0, if: :with_proposal? }
  validate  :validate_minimum_amount, if: :with_proposal?

  after_destroy :change_status_item
  before_save   :set_status_and_number
  after_save    :change_status_item

  scope :by_item_id, lambda { |item_id|
    where { |bid| bid.item_id.eq(item_id) }
  }

  scope :by_round, lambda { |round|
    where { |bid| bid.round.eq(round) }
  }

  scope :not_without_proposal, lambda {
    where { status.not_eq(TradingItemBidStatus::WITHOUT_PROPOSAL) }
  }

  scope :creditor_ids, lambda { |creditor_ids|
    joins { accreditation_creditor }.where { accreditation_creditor.creditor_id.in(creditor_ids) }
  }

  scope :by_licitation_process, lambda{|licitation_process_id|
    joins{ trading }.where{ trading.purchase_process_id.eq licitation_process_id}
  }

  scope :by_accreditation_creditor, lambda{ |accreditation_creditor_id|
    joins { accreditation_creditor }.where { accreditation_creditor.id.eq accreditation_creditor_id }
  }

  def percent
    return unless amount > BigDecimal("0")

    if lowest_bid_or_proposal_amount && amount != lowest_bid_or_proposal_amount
      ( (amount - lowest_bid_or_proposal_amount) / lowest_bid_or_proposal_amount * BigDecimal('100') ).round(2)
    else
      BigDecimal("0")
    end
  end

  def amount_with_reduction
    lowest_bid_or_proposal_amount - reduction_value
  end

  private
  def set_status_and_number
    self.status = TradingBidStatusChooser.new(self).choose unless status
    self.number = TradingBidNumberCalculator.calculate(self.item) unless number
  end

  def change_status_item
    TradingItemStatusChanger.change(self.item)
  end

  def reduction_value
    if reduction_rate_value > 0
      reduction_rate_value
    elsif reduction_rate_percent > 0
      lowest_bid_or_proposal_amount * (reduction_rate_percent / BigDecimal('100'))
    else
      BigDecimal('0.01')
    end
  end

  def validate_minimum_amount
    return unless lowest_bid_or_proposal_amount.present?

    if amount >= lowest_bid_or_proposal_amount && self.new_record?
      errors.add(:amount, :less_than, :count => I18n::Alchemy::NumericParser.localize(lowest_bid_or_proposal_amount))
    end
  end

  def item_lowest_proposal_unit_price
    return unless item.lowest_proposal

    item.lowest_proposal.unit_price
  end
end

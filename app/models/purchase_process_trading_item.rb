class PurchaseProcessTradingItem < Compras::Model
  attr_accessible :reduction_rate_value, :reduction_rate_percent, :status, as: :trading_user
  attr_accessible :trading_id, :item_id, :lot, :bids_attributes, :negotiation_attributes,
    :status

  has_enumeration_for :status, with: PurchaseProcessTradingItemStatus,
    create_helpers: true, create_scopes: true

  belongs_to :trading, class_name: 'PurchaseProcessTrading'
  belongs_to :item, class_name: 'PurchaseProcessItem'

  has_many :bids, class_name: 'PurchaseProcessTradingItemBid',
    foreign_key: :item_id, dependent: :destroy, order: 'number DESC'
  has_many :ratification_items, class_name: 'LicitationProcessRatificationItem'
  has_many :accreditation_creditors, through: :trading

  has_one :negotiation, class_name: 'PurchaseProcessTradingItemNegotiation',
    dependent: :restrict, inverse_of: :item

  delegate :lot, :quantity, to: :item, allow_nil: true, prefix: true
  delegate :lot?, :item?, :purchase_process_id, to: :trading, allow_nil: true

  validates :reduction_rate_value, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validates :reduction_rate_percent, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validate :validate_reductions

  accepts_nested_attributes_for :bids, allow_destroy: true
  accepts_nested_attributes_for :negotiation, allow_destroy: true,
    reject_if: proc { |attributes|  attributes[:amount].blank? || BigDecimal(attributes[:amount]) <= 0 }

  scope :trading_id, ->(trading_id) do
    where { |query| query.trading_id.eq(trading_id) }
  end

  scope :status_pending, ->() do
    where(status: PurchaseProcessTradingItemStatus::PENDING)
  end

  scope :status_closed, ->() do
    where(status: PurchaseProcessTradingItemStatus::CLOSED)
  end

  scope :lot, ->(lot) do
    where { |query| query.lot.eq(lot) }
  end

  scope :item_id, ->(item_id) do
    where { |query| query.item_id.eq(item_id) }
  end

  scope :by_item_or_lot, -> (item_or_lot) do
    where("lot = ? or item_id = ?", item_or_lot, item_or_lot)
  end

  scope :purchase_process_id, ->(purchase_process_id) do
    joins { trading }.
    where { trading.purchase_process_id.eq(purchase_process_id) }
  end

  def self.creditor_winner_items(creditor_id)
    [].tap do |items|
      scoped.closed.each do |trading_item|
        items << trading_item if TradingItemWinner.new(trading_item).creditor.try(:id) == creditor_id
      end
    end
  end

  def to_s
    return lot.to_s if lot

    item.to_s
  end

  def creditors_ordered(purchase_process_accreditation_creditor_repository = PurchaseProcessAccreditationCreditor)
    if item?
      accreditation_creditors.by_lowest_proposal(item.id)
    else
      purchase_process_accreditation_creditor_repository.by_lowest_proposal_on_lot(purchase_process_id, lot)
    end
  end

  def creditors_ordered_outer(purchase_process_accreditation_creditor_repository = PurchaseProcessAccreditationCreditor)
    if item?
      accreditation_creditors.by_lowest_proposal_outer(item.id)
    else
      purchase_process_accreditation_creditor_repository.by_lowest_proposal_outer_on_lot(purchase_process_id, lot)
    end
  end

  def creditors_selected
    creditors_ordered.selected_creditors
  end

  def creditors_benefited
    creditors_selected.
      benefited.
      less_or_equal_to_trading_bid_value(minimum_amount_for_benefited).
      to_a.
      uniq
  end

  def lowest_proposal
    return unless creditor_with_lowest_proposal

    if item?
      creditor_with_lowest_proposal.creditor_proposal_by_item(purchase_process_id, item)
    else
      creditor_with_lowest_proposal.creditor_proposal_by_lot(purchase_process_id, lot)
    end
  end

  def lowest_bid
    bids.with_proposal.first
  end

  def last_bid
    bids.not_without_proposal.reorder(:id).last
  end

  def last_bid_with_proposal
    bids.with_proposal.reorder(:id).last
  end

  def bids_historic
    bids.not_without_proposal.reorder('number DESC')
  end

  def lowest_bid_or_proposal_amount
    lowest_bid.try(:amount) || lowest_proposal.try(:unit_price)
  end

  def lowest_bid_or_proposal_accreditation_creditor
    lowest_bid.try(:accreditation_creditor) || creditor_with_lowest_proposal
  end

  def quantity
    #TODO essa quantidade irá mudar quando a contagem for por lote de itens
    item.quantity
  end

  def close!
    update_column :status, PurchaseProcessTradingItemStatus::CLOSED
  end

  def pending!
    update_column :status, PurchaseProcessTradingItemStatus::PENDING
  end

  def benefited_tie?
    return false unless accreditation_creditor_winner

    !accreditation_creditor_winner.benefited? && creditors_benefited.any?
  end

  def item_or_lot
    item || lot
  end

  def creditor_winner(trading_item_winner = TradingItemWinner)
    trading_item_winner.new(self).creditor
  end

  def amount_winner(trading_item_winner = TradingItemWinner)
    trading_item_winner.new(self).amount
  end

  private

  def accreditation_creditor_winner
    return unless creditor_winner

    creditor_winner.
      purchase_process_accreditation_creditors.
      purchase_process_id(purchase_process_id).first
  end

  def minimum_amount_for_benefited(percent_rate = BigDecimal('5'))
    lowest_bid_or_proposal_amount + (lowest_bid_or_proposal_amount * (percent_rate / BigDecimal('100')))
  end

  def creditor_with_lowest_proposal
    creditors_selected.last
  end

  def validate_reductions
    return unless reduction_rate_value.present? && reduction_rate_percent.present?

    if reduction_rate_value > 0 && reduction_rate_percent > 0
      errors.add(:reduction_rate_value, :only_one_reduction_allowed)
    end
  end
end

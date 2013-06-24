class PurchaseProcessTradingItem < Compras::Model
  attr_accessible :reduction_rate_value, :reduction_rate_percent, as: :trading_user
  attr_accessible :trading_id, :item_id, :lot, :bids_attributes, :negotiation_attributes,
    :status

  has_enumeration_for :status, with: PurchaseProcessTradingItemStatus,
    create_helpers: true, create_scopes: true

  belongs_to :trading, class_name: 'PurchaseProcessTrading'
  belongs_to :item, class_name: 'PurchaseProcessItem'

  has_many :bids, class_name: 'PurchaseProcessTradingItemBid',
    foreign_key: :item_id, dependent: :destroy, order: 'number DESC'
  has_many :purchase_process_accreditation_creditors, through: :item
  has_many :ratification_items, class_name: 'LicitationProcessRatificationItem'

  has_one :negotiation, class_name: 'PurchaseProcessTradingItemNegotiation',
    dependent: :restrict, inverse_of: :item

  delegate :lot, :quantity, to: :item, allow_nil: true, prefix: true

  validates :reduction_rate_value, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validates :reduction_rate_percent, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validate :validate_reductions

  accepts_nested_attributes_for :bids, allow_destroy: true
  accepts_nested_attributes_for :negotiation, allow_destroy: true,
    reject_if: proc { |attributes|  attributes[:amount].blank? || BigDecimal(attributes[:amount]) <= 0 }

  scope :trading_id, ->(trading_id) do
    where { |query|
      query.trading_id.eq(trading_id)
    }
  end

  def self.creditor_winner_items(creditor_id, trading_id)
    [].tap do |items|
      scoped.trading_id(trading_id).closed.each do |trading_item|
        items << trading_item if TradingItemWinner.new(trading_item).creditor.id == creditor_id
      end
    end
  end

  def to_s
    return lot.to_s if lot

    item.to_s
  end

  def creditors_ordered
    purchase_process_accreditation_creditors.by_lowest_proposal(item.id)
  end

  def creditors_ordered_outer
    purchase_process_accreditation_creditors.by_lowest_proposal_outer(item.id)
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

    creditor_with_lowest_proposal.creditor_proposal_by_item(item)
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
    creditors_benefited.any?
  end

  private

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

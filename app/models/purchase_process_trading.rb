class PurchaseProcessTrading < Compras::Model
  attr_accessible :purchase_process_id, :items_attributes, :observation

  belongs_to :purchase_process, class_name: 'LicitationProcess'

  has_many :accreditation_creditors, through: :purchase_process_accreditation,
    source: :purchase_process_accreditation_creditors
  has_many :creditors, through: :accreditation_creditors
  has_many :items, class_name: 'PurchaseProcessTradingItem', foreign_key: :trading_id,
    order: :id
  has_many :items_bids, through: :items, source: :bids, order: :round

  has_one :judgment_form, through: :purchase_process
  has_one :purchase_process_accreditation, through: :purchase_process

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :kind, :kind_humanize, :item?, :lot?, to: :judgment_form, allow_nil: true

  validates :purchase_process, presence: true

  def to_s
    purchase_process.to_s
  end

  def items_by_winner(accreditation_creditor)
    items.select do |item|
      item.lowest_bid_or_proposal_accreditation_creditor == accreditation_creditor
    end
  end

  def creditors_with_lowest_proposal
    items.map { |item| item.lowest_bid_or_proposal_accreditation_creditor }.compact.uniq
  end

  def creditors_winners(trading_item_winner = TradingItemWinner)
    items.map { |item| trading_item_winner.new(item).creditor }.compact.uniq
  end

  def allow_negotiation?
    items.pending.count == 0
  end
end

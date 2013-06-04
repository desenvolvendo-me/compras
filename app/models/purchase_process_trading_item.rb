class PurchaseProcessTradingItem < Compras::Model
  attr_accessible :trading_id, :item_id, :lot, :reduction_rate_value,
    :reduction_rate_percent

  belongs_to :trading, class_name: 'PurchaseProcessTrading'
  belongs_to :item, class_name: 'PurchaseProcessItem'

  has_many :bids, class_name: 'PurchaseProcessTradingItemBid',
    foreign_key: :item_id, dependent: :destroy, order: 'number DESC'
  has_many :purchase_process_accreditation_creditors, through: :item

  delegate :lot, to: :item, allow_nil: true, prefix: true

  def to_s
    return lot.to_s if lot

    item.to_s
  end

  def creditors_ordered
    purchase_process_accreditation_creditors.by_lowest_proposal(item.id)
  end

  def creditors_selected
    creditors_ordered.selected_creditors
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

  def bids_historic
    bids.not_without_proposal.reorder('number DESC')
  end

  private

  def creditor_with_lowest_proposal
    creditors_selected.last
  end
end

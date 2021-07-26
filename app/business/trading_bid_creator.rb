class TradingBidCreator
  def initialize(item, options = {})
    @item           = item
    @bid_repository = options.fetch(:bid_repository) { PurchaseProcessTradingItemBid }
  end

  def self.create_items_bids!(trading)
    trading.items.each do |item|
      new(item).create!
    end
  end

  def self.create!(*args)
    new(*args).create!
  end

  def create!
    if clear_bids_before_creation?
      clear_bids
    end

    if allow_creation?
      available_accreditation_creditors.each do |creditor|
        create_bid(creditor)
      end
    end
  end

  private

  attr_reader :bid_repository, :item

  def clear_bids_before_creation?
    bids.not_without_proposal.empty?
  end

  def clear_bids
    bids.destroy_all
  end

  def allow_creation?
    bids.empty? || all_creditors_gave_a_bid_for_last_round?
  end

  def bids
    item.bids
  end

  def last_round
    @last_round ||= bids.not_without_proposal.maximum(:round) || 0
  end

  def current_round
    if bids.empty?
      1
    elsif last_round.pred == 0 && creditors_for_last_round.count < item.creditors_selected.count
      last_round
    else
      last_round.succ
    end
  end

  def creditors_with_bid_for_last_round
    bids.
      with_proposal.
      by_round(last_round).
      reorder('amount DESC').
      map(&:accreditation_creditor)
  end

  def creditors_for_last_round
    bids.
      not_without_proposal.
      by_round(last_round).
      reorder('amount DESC').
      map(&:accreditation_creditor)
  end

  def available_accreditation_creditors
    if bids.empty?
      item.creditors_selected
    elsif last_round.pred == 0 && creditors_for_last_round.count < item.creditors_selected.count
      item.creditors_selected - creditors_for_last_round
    elsif creditors_with_bid_for_last_round.count > 1
      creditors_with_bid_for_last_round
    else
      []
    end
  end

  def creditors_without_bid_for_last_round
    bids.
      without_proposal.
      by_round(last_round)
  end

  def all_creditors_gave_a_bid_for_last_round?
    creditors_without_bid_for_last_round.empty?
  end

  def create_bid(accreditation_creditor)
    bid_repository.create!(
      round: current_round,
      status: TradingItemBidStatus::WITHOUT_PROPOSAL,
      amount: 0,
      purchase_process_accreditation_creditor_id: accreditation_creditor.id,
      item_id: item.id)
  end
end

class PurchaseProcessItemWinner
  def initialize(item, options = {})
    @item = item
    @purchase_process = item.licitation_process
    @trading_item_repository = options.fetch(:trading_item_repository) { PurchaseProcessTradingItem }
    @creditor_proposal_repository = options.fetch(:creditor_proposal_repository) { PurchaseProcessCreditorProposal }
  end

  def self.winner(*args)
    new(*args).winner
  end

  def winner
    if purchase_process.trading?
      creditor_trading_winner
    else
      creditor_proposal_winner
    end
  end

  private

  attr_reader :item, :purchase_process, :trading_item_repository, :creditor_proposal_repository

  def creditor_trading_winner
    return unless trading_winner

    trading_winner.creditor_winner
  end

  def creditor_proposal_winner
    return unless proposal_winner

    proposal_winner.creditor
  end

  def judgment_form_kind
    purchase_process.judgment_form_kind
  end

  def trading_winner
    send "trading_item_by_#{judgment_form_kind}"
  end

  def proposal_winner
    send "best_proposal_by_#{judgment_form_kind}"
  end

  def trading_item_by_lot
    trading_item_repository.
      purchase_process_id(purchase_process.id).
      lot(item.lot).
      first
  end

  def trading_item_by_item
    trading_item_repository.
      item_id(item.id).
      first
  end

  def trading_item_by_global
  end

  def best_proposal_by_lot
    creditor_proposal_repository.
      licitation_process_id(purchase_process.id).
      by_lot(item.lot).
      winning_proposals.
      first
  end

  def best_proposal_by_item
    creditor_proposal_repository.
      by_item_id(item.id).
      winning_proposals.
      first
  end

  def best_proposal_by_global
    creditor_proposal_repository.
      licitation_process_id(purchase_process.id).
      winning_proposals.
      first
  end
end

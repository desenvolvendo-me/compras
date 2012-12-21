class TradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def trading_item_lowest_proposal_value
    number_with_precision super if super
  end

  def minimum_limit
    number_with_precision super if super
  end

  def show_undo_button?
    trading_item.proposals_for_round_of_bids?

  end

  def percent_by_item_and_round
    return unless component.persisted?

    number_with_precision TradingItemBidPercentCalculator.new(component).calculate!
  end

  def created_at_second
    I18n.l component.created_at, :format => :second
  end

  def amount
    number_with_precision super if super
  end

  def last_valid_amount_by_bidder_and_item_and_round
    if component.amount > 0
      amount
    elsif super
      number_with_precision(super)
    else
      0
    end
  end
end

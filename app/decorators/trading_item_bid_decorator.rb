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
end

class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::NumberHelper

  def licitation_opened?
    bid_opening <= Date.today && bid_opening_time.try(:seconds_since_midnight) <= Time.now.try(:seconds_since_midnight)
  end

  def bids_finished?
    bids.all? {|x| x.closed? } if bids.present?
  end

  def minimum_proposal_item item_id
    number_to_currency super(item_id)
  end
end

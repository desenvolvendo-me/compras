class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  def licitation_opened?
    component.bid_opening <= Date.today && component.bid_opening_time.try(:seconds_since_midnight) <= Time.now.try(:seconds_since_midnight)
  end

  def bids_finished?
    bids.all? {|x| x.closed? } if bids.present?
  end
end

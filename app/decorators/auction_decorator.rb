class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  def licitation_opened?
    bid_opening <= Date.today && bid_oppening_time.try(:seconds_since_midnight) <= Time.now.try(:seconds_since_midnight)
  end

  def bids_finished?
    bids.all? {|x| x.closed? } if bids.present?
  end
end

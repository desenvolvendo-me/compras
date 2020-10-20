class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  def licitation_opened?
    bid_opening <= Date.today && bid_opening_time.try(:seconds_since_midnight) <= Time.now.try(:seconds_since_midnight)
  end

  def bids_finished?
    bids.all?(&:closed?) if bids.present?
  end

  def auction_suspension_message
    return unless suspension.present?

    if suspension.reactivation_date.blank?
      'Pregão suspendido em ' + I18n.l(suspension.suspension_date)
    else
      'Pregão reativado em ' + I18n.l(suspension.reactivation_date)
    end
  end
end

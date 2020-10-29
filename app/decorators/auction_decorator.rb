class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::NumberHelper

  def licitation_opened?
    component.bid_opening <= Date.today && component.bid_opening_time.try(:seconds_since_midnight) <= Time.now.try(:seconds_since_midnight)
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

  def bid_opening_time
    return super.strftime("%H:%Mh") if super
    '-'
  end

  def notice_availability
    super.strftime('%d/%m/%Y às %H:%Mh') if super
  end

  def proposal_delivery
    I18n.l super if super
  end

  def bid_opening
    I18n.l super if super
  end

  def end_dispute_date
    I18n.l(super || Date.today)
  end

  def end_dispute_time
    (super || Time.now).strftime('%H:%M')
  end

  def restart_dispute_date
    I18n.l(super || Date.today)
  end

  def restart_dispute_time
    (super || Time.now).strftime('%H:%M')
  end

  def minimum_proposal_item item_id
    number_to_currency super(item_id)
  end
end

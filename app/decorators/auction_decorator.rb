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

  def session_suspension_message
    str = ''
    if component.session_ended?
      str << I18n.t("auction.messages.ended_session",
             end_date: end_dispute_date,
             end_time: end_dispute_time)
      if component.session_restarted?
        str << "</br>" + I18n.t("auction.messages.restarded_session",
          restart_date: restart_dispute_date,
          restart_time: restart_dispute_time)
      end
    end

    str.html_safe
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

  def status
    priority_list = Hash.new
    priority_list[1] = 'Pregão Aberto' unless component.proposal_delivery&.future?
    priority_list[2] = 'Pregão Suspenso' if suspended?
    priority_list[3] = 'Pregão Reativado' if reactivated?
    priority_list[4] = 'Pregão realizado no dia' if component.bid_opening.today?
    priority_list[5] = 'Fase de Lances Suspensa' if session_ended?
    priority_list[6] = 'Fase de Lances Reiniciada' if session_restarted?

    if (priority_list.keys & [2,4]) == [2,4] and !priority_list.keys.include?(3)
      return priority_list[2]
    end

    priority_list[priority_list.keys.max]
  end
end

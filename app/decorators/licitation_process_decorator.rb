#encoding: utf-8
class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def envelope_delivery_time
    localize(super, :format => :hour) if super
  end

  def envelope_opening_time
    localize(super, :format => :hour) if super
  end

  def parent_url(parent)
    if parent
      routes.edit_administrative_process_path(parent)
    else
      routes.licitation_processes_path
    end
  end

  def all_licitation_process_classifications_groupped
    all_licitation_process_classifications.group_by(&:bidder)
  end

  def edit_path
    if component.presence_trading? && component.trading.present?
      routes.edit_trading_path(component.trading)
    else
      routes.edit_licitation_process_path(component)
    end
  end

  def edit_link
    if component.presence_trading? && component.trading.present?
      'Voltar ao pregão presencial'
    else
      'Voltar ao processo licitatório'
    end
  end

  def not_updatable_message
    t('licitation_process.messages.not_updatable') unless updatable?
  end
end

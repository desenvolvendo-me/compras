# encoding: utf-8
class AdministrativeProcessDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def value_estimated
    number_to_currency super if super
  end

  def total_allocations_value
    number_with_precision super if super
  end

  def date
    localize super if super
  end

  def cant_print_message
    t('administrative_process.messages.cant_print') unless released?
  end

  def cant_build_licitation_process_message
    return t('administrative_process.messages.cant_build_licitation_process.not_allowed') unless allow_licitation_process?

    t('administrative_process.messages.cant_build_licitation_process.not_released') unless released?
  end
end

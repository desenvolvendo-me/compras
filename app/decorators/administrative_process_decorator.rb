# encoding: utf-8
class AdministrativeProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :date, :object_type, :summarized_object, :status

  def value_estimated
    number_to_currency super if super
  end

  def total_allocations_value
    number_with_precision super if super
  end

  def date
    localize super if super
  end

  def not_released_message
    t('administrative_process.messages.not_released') unless released?
  end

  def cant_build_licitation_process_message
    return t('administrative_process.messages.licitation_process_not_allowed') unless allow_licitation_process?

    not_released_message
  end

  def code_and_year
    "#{process}/#{year}"
  end
end

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
end

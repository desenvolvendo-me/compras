# encoding: utf-8
class LicitationProcessClassificationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_value
    number_with_precision super if super
  end

  def total_value
    number_with_precision super if super
  end
end

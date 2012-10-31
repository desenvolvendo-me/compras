class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def readonly_reduction_percent
    if component.minimum_reduction_value?
      { :readonly => 'readonly' }
    else
      {}
    end
  end

  def readonly_reduction_value
    if component.minimum_reduction_percent?
      { :readonly => 'readonly' }
    else
      {}
    end
  end
end

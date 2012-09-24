class PriceRegistrationItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_to_currency(super, :format => "%n") if super
  end
end
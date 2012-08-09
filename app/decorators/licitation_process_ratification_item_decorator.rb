class LicitationProcessRatificationItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_to_currency(super, :format => "%n") if super
  end

  def total_price
    number_to_currency(super, :format => "%n") if super
  end

  def id_or_mustache_variable
    component.id || "{{id}}"
  end

  def code_or_mustache_variable
    component.code || "{{code}}"
  end

  def description_or_mustache_variable
    component.description || "{{description}}"
  end

  def reference_unit_or_mustache_variable
    component.reference_unit || "{{reference_unit}}"
  end

  def quantity_or_mustache_variable
    component.quantity || "{{quantity}}"
  end

  def total_price_or_mustache_variable
    total_price || "{{total_price}}"
  end

  def unit_price_or_mustache_variable
    unit_price || "{{unit_price}}"
  end
end

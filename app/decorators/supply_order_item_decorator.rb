class SupplyOrderItemDecorator
  include Decore
  include ActionView::Helpers::NumberHelper

  def nested_form_path
    context = component.service_without_quantity? ? 'value' : 'quantity'

    "supply_order_items/form_#{context}"
  end

  def unit_price
    number_with_precision(component.unit_price) if component.unit_price
  end

  def total_price
    number_with_precision(component.total_price) if component.total_price
  end

  def authorized_value
    number_with_precision(component.authorized_value) if component.authorized_value
  end

  def value_balance
    number_with_precision(component.value_balance) if component.value_balance
  end

  def quantity
    component.quantity || 0
  end
end

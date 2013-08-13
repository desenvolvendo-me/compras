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

  def authorized_value
    number_with_precision super if super
  end

  def supply_order_item_value_balance
    value = component.supply_order_item_value_balance

    number_with_precision value if value
  end

  def creditor_proposal_id_or_mustache_variable
    purchase_process_creditor_proposal_id || "{{purchase_process_creditor_proposal_id}}"
  end

  def trading_item_id_or_mustache_variable
    purchase_process_trading_item_id || "{{purchase_process_trading_item_id}}"
  end

  def purchase_process_item_id_or_mustache_variable
    purchase_process_item_id || "{{purchase_process_item_id}}"
  end

  def realignment_price_item_id_or_mustache_variable
    realignment_price_item_id || "{{realignment_price_item_id}}"
  end

  def code_or_mustache_variable
    code || "{{code}}"
  end

  def description_or_mustache_variable
    description || "{{description}}"
  end

  def reference_unit_or_mustache_variable
    reference_unit || "{{reference_unit}}"
  end

  def quantity_or_mustache_variable
    quantity || "{{quantity}}"
  end

  def total_price_or_mustache_variable
    total_price || "{{total_price}}"
  end

  def unit_price_or_mustache_variable
    unit_price || "{{unit_price}}"
  end
end

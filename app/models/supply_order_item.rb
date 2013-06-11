class SupplyOrderItem < Compras::Model
  attr_accessible :authorization_quantity, :licitation_process_ratification_item_id,
    :supply_order_id

  belongs_to :supply_order
  belongs_to :licitation_process_ratification_item

  delegate :material, :reference_unit, :unit_price, :total_price,
    :supply_order_item_balance, to: :licitation_process_ratification_item, allow_nil: true

  def authorized_quantity
    SupplyOrderItem.where { |query|
      query.licitation_process_ratification_item_id.eq(licitation_process_ratification_item_id)
    }.sum(:authorization_quantity) || 0
  end

  def quantity
    licitation_process_ratification_item.try(:quantity).to_i
  end

  def balance
    quantity - authorized_quantity
  end

  orderize "id DESC"
  filterize

  validate :authorization_quantity_should_be_lower_than_quantity

  private

  def authorization_quantity_should_be_lower_than_quantity
    if real_authorization_quantity > supply_order_item_balance.to_i
      errors.add(:authorization_quantity, :less_than_or_equal_to, count: supply_order_item_balance.to_i + authorization_quantity_was.to_i)
    end
  end

  def real_authorization_quantity
    authorization_quantity.to_i - authorization_quantity_was.to_i
  end
end

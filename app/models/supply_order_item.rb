class SupplyOrderItem < Compras::Model
  attr_accessible :authorization_quantity, :licitation_process_ratification_item_id,
    :supply_order_id

  belongs_to :supply_order
  belongs_to :licitation_process_ratification_item

  delegate  :material, :reference_unit, :unit_price, :total_price,
    to: :licitation_process_ratification_item, allow_nil: true
  delegate :supply_order_item_balance, :quantity,
    to: :licitation_process_ratification_item, allow_nil: true, prefix: true

  def authorized_quantity
    SupplyOrderItem.where { |query|
      query.licitation_process_ratification_item_id.eq(licitation_process_ratification_item_id)
    }.sum(:authorization_quantity) || 0
  end

  def balance
    quantity - authorized_quantity
  end

  orderize "id DESC"
  filterize

  validate :authorization_quantity_should_be_lower_than_quantity

  orderize "id DESC"
  filterize

  private

  def authorization_quantity_should_be_lower_than_quantity
    if real_authorization_quantity > supply_order_item_balance
      errors.add(:authorization_quantity, :less_than_or_equal_to, count: supply_order_item_balance + authorization_quantity_was )
    end
  end

  def authorization_quantity_was
    super || 0
  end

  def authorization_quantity
    super || 0
  end

  def supply_order_item_balance
    licitation_process_ratification_item_supply_order_item_balance || 0
  end

  def quantity
    licitation_process_ratification_item_quantity || 0
  end

  def real_authorization_quantity
    authorization_quantity - authorization_quantity_was
  end
end

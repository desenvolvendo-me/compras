class SupplyOrderItem < Compras::Model
  attr_accessible :authorization_quantity, :authorization_value,
    :licitation_process_ratification_item_id, :supply_order_id

  belongs_to :supply_order
  belongs_to :licitation_process_ratification_item

  delegate :material, :reference_unit, :unit_price, :total_price,
    :supply_order_item_balance, :supply_order_item_value_balance,
    to: :licitation_process_ratification_item, allow_nil: true
  delegate :control_amount?, to: :material, allow_nil: true

  validates :authorization_value,    numericality: { greater_than: 0 }, unless: :authorization_quantity
  validates :authorization_quantity, numericality: { greater_than: 0 }, unless: :authorization_value

  validate :authorization_quantity_should_be_lower_than_quantity
  validate :authorization_value_should_be_lower_than_value, if: :authorization_value_changed?

  orderize "id DESC"
  filterize

  def authorized_quantity
    SupplyOrderItem.where { |query|
      query.licitation_process_ratification_item_id.eq(licitation_process_ratification_item_id)
    }.sum(:authorization_quantity) || 0
  end

  def authorized_value
    SupplyOrderItem.where { |query|
      query.licitation_process_ratification_item_id.eq(licitation_process_ratification_item_id)
    }.sum(:authorization_value) || 0
  end

  def quantity
    licitation_process_ratification_item.try(:quantity).to_i
  end

  def value
    licitation_process_ratification_item.try(:unit_price).to_f
  end

  def balance
    quantity - authorized_quantity
  end

  def value_balance
    value - authorized_value
  end

  private

  def authorization_quantity_should_be_lower_than_quantity
    if real_authorization_quantity > supply_order_item_balance.to_i
      errors.add(:authorization_quantity, :less_than_or_equal_to,
        count: supply_order_item_balance.to_i + authorization_quantity_was.to_i)
    end
  end

  def authorization_value_should_be_lower_than_value
    if real_authorization_value > supply_order_item_value_balance
      errors.add(:authorization_value, :less_than_or_equal_to, count: authorization_value_limit)
    end
  end

  def real_authorization_quantity
    authorization_quantity.to_i - authorization_quantity_was.to_i
  end

  def real_authorization_value
    authorization_value - (old_authorization_value || 0)
  end

  def authorization_value_limit(numeric_parser = ::I18n::Alchemy::NumericParser)
    numeric_parser.localize(supply_order_item_value_balance + old_authorization_value)
  end

  def old_authorization_value
    authorization_value_was || 0
  end
end

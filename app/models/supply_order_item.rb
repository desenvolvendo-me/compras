class SupplyOrderItem < Compras::Model
  # include BelongsToResource

  attr_accessible :authorization_quantity, :authorization_value,
                  :pledge_item_id, :supply_order_id, :material_id, :quantity, :balance

  attr :balance

  belongs_to :supply_order
  belongs_to :material

  belongs_to :pledge_item

  has_many :supplied_invoices, class_name: 'SupplyOrderItemInvoice'

  delegate :unit_price, to: :pledge_item, allow_nil: true
  delegate :quantity, :balance, :estimated_total_price,
           to: :pledge_item, allow_nil: true, prefix: true
  delegate :service_without_quantity?, :reference_unit, to: :material, allow_nil: true

  validate :authorization_quantity_should_be_lower_than_quantity
  validate :authorization_value_should_be_lower_than_value, if: :authorization_value_changed?

  orderize "id DESC"
  filterize

  scope :by_pledge_item_id, ->(pledge_item_id) do
    where { |query| query.pledge_item_id.eq(pledge_item_id) }
  end

  def authorized_quantity
    SupplyOrderItem.where { |query|
      query.pledge_item_id.eq(pledge_item_id)
    }.sum(:authorization_quantity) || 0
  end

  def authorized_value
    SupplyOrderItem.where { |query|
      query.pledge_item_id.eq(pledge_item_id)
    }.sum(:authorization_value) || 0
  end

  def value
    BigDecimal("#{unit_price}")
  end

  def value_balance
    value - authorized_value
  end

  def total_price
    BigDecimal("#{pledge_item_estimated_total_price}")
  end

  def supply_order_item_balance
    item = pledge_item(false)

    item ? item.supply_order_item_balance : 0
  end

  def supply_order_item_value_balance
    item = pledge_item(false)

    item ? item.supply_order_item_value_balance : 0
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
    authorization_value - old_authorization_value
  end

  def authorization_value_limit(numeric_parser = ::I18n::Alchemy::NumericParser)
    numeric_parser.localize(supply_order_item_value_balance + old_authorization_value)
  end

  def old_authorization_value
    authorization_value_was || 0
  end
end

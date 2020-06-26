class SupplyRequestItem < Compras::Model
  attr_accessible :authorization_quantity, :authorization_value, :material_id,
                  :pledge_item_id, :quantity, :requested_quantity, :supply_request_id, :balance_contract

  attr :balance, :balance_unit

  attr_accessor :get_unit_price

  belongs_to :supply_request
  belongs_to :material
  belongs_to :pledge_item

  delegate :unit_price, to: :pledge_item, allow_nil: true
  delegate :quantity, :balance, :estimated_total_price,
           to: :pledge_item, allow_nil: true, prefix: true
  delegate :service_without_quantity?, :reference_unit, to: :material, allow_nil: true

  #validates :authorization_value, numericality: {greater_than: 0}, unless: :authorization_quantity
  #validates :authorization_quantity, numericality: {greater_than: 0}, unless: :authorization_value

  validate :authorization_quantity_should_be_lower_than_quantity
  validate :authorization_value_should_be_lower_than_value, if: :authorization_value_changed?

  orderize "id DESC"
  filterize

  scope :by_pledge_item_id, ->(pledge_item_id) do
    where { |query| query.pledge_item_id.eq(pledge_item_id) }
  end

  scope :by_material_id, lambda{|material|
    unless material.blank?
      where{ material_id.eq(material) }
    end
  }

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

  def supply_request_item_balance
    item = pledge_item(false)

    item ? item.supply_request_item_balance : 0
  end

  def supply_request_item_value_balance
    item = pledge_item(false)

    item ? item.supply_request_item_value_balance : 0
  end

  def get_unit_price
    material_id = self.material_id
    supply_request_id = self.supply_request.try(:id)
    creditor_id = self.supply_request.try(:creditor).try(:id)

    if supply_request_id && creditor_id && material_id
      material_unit_value = SupplyRequestItem.get_material_unit_value(supply_request_id, creditor_id, material_id)
      quantity_unit = self.material.quantity_unit
      material_unit_value.to_f / quantity_unit.to_f
    end
  end

  def self.get_material_unit_value(supply_request_id, creditor_id, material_id)
    realignment_price_items = RealignmentPriceItem.joins { purchase_process.supply_requests }
                                  .joins { creditor }
                                  .joins { material }
                                  .where { material.id.eq(material_id) }
                                  .where { creditor.id.eq(creditor_id) }
                                  .where { purchase_process.supply_requests.id.eq(supply_request_id) }

    realignment_price_items.last ? realignment_price_items.last.price.to_f : 0
  end

  def authorization_quantity_should_be_lower_than_quantity
    if real_authorization_quantity > supply_request_item_balance.to_i
      errors.add(:authorization_quantity, :less_than_or_equal_to,
                 count: supply_request_item_balance.to_i + authorization_quantity_was.to_i)
    end
  end

  def authorization_value_should_be_lower_than_value
    if real_authorization_value > supply_request_item_value_balance
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
    numeric_parser.localize(supply_request_item_value_balance + old_authorization_value)
  end

  def old_authorization_value
    authorization_value_was || 0
  end
end

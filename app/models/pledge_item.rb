class PledgeItem < UnicoAPI::Resources::Contabilidade::PledgeItem
  include ActiveResource::Associations

  belongs_to :material

  delegate :service_without_quantity?, :reference_unit, to: :material, allow_nil: true

  schema do
    decimal :unit_price, :estimated_total_price
  end

  def supply_order_items(repository = SupplyOrderItem)
    repository.by_pledge_item_id id
  end

  def authorized_quantity
    supply_order_items.sum(&:authorization_quantity)
  end

  def authorized_value
    supply_order_items.sum(&:authorization_value)
  end

  def supply_order_item_balance
    quantity - authorized_quantity
  end

  def supply_order_item_value_balance
    estimated_total_price - authorized_value
  end
end

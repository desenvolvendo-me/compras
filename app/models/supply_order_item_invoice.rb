class SupplyOrderItemInvoice < Compras::Model
  attr_accessible :supply_order_item_id, :invoice_id, :quantity_supplied

  attr_accessor :total_items_value

  belongs_to :supply_order_item
  belongs_to :invoice
end
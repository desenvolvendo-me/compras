module SupplyOrdersHelper
  def init_object object, material
    aux = object
    object = object.items.select{|x| x.material_id == material.id}
    object = SupplyOrderItem.new(supply_order_id: aux.id) if object.blank?

    object
  end

  def init_item_invoices object, material
    aux = object.supply_order
    object = object.supply_order_item_invoices.where(supply_order_item_id: material.id).last
    object = SupplyOrderItemInvoice.new(supply_order_id: aux.id) if object.blank?

    object
  end
end
module SupplyOrdersHelper
  def init_object object, material
    aux = object
    object = object.items.where(material_id: material.id).last
    object = aux.items.build if object.blank?

    object
  end
end
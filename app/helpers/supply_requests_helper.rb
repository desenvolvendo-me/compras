module SupplyRequestsHelper

  def disabled_material(object)
    return true if object.new_record?
  end

end
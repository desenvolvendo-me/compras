class PurchaseSolicitationItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :material, :lot, :reference_unit, :brand, :quantity, :unit_price, :estimated_total_price

  def material_grid_mustache
    material || "{{material}}"
  end

  def lot_grid_mustache
    lot || "{{lot}}"
  end

  def reference_unit_grid_mustache
    reference_unit || "{{reference_unit}}"
  end

  def brand_grid_mustache
    brand || "{{brand}}"
  end

  def unit_price_grid_mustache
    unit_price || "{{unit_price}}"
  end

  def estimated_total_price_grid_mustache
    estimated_total_price || "{{estimated_total_price}}"
  end
end

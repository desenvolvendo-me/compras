class Invoice < Compras::Model
  attr_accessible :number

  belongs_to :supply_order
end

class Invoice < Compras::Model
  attr_accessible :number,:release_date,:date,:value

  belongs_to :supply_order

end

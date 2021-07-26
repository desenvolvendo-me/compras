class BalanceAdjustmentItem < Compras::Model
  attr_accessible :quantity_new, :quantity, :material_id, :balance_adjustment_id

  belongs_to :balance_adjustment
  belongs_to :material
end

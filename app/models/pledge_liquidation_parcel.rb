class PledgeLiquidationParcel < Compras::Model
  attr_accessible :value, :number, :pledge_liquidation_id

  belongs_to :pledge_liquidation

  validates :value, :presence => true
end

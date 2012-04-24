class AddPrecisionAndScaleToPledgeLiquidations < ActiveRecord::Migration
  def change
    change_column :pledge_liquidations, :value, :decimal, :precision => 10, :scale => 2
  end
end

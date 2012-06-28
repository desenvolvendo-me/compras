class AddPrecisionAndScaleToValueOnPledgeValues < ActiveRecord::Migration
  def change
    change_column :compras_pledge_parcels, :value, :decimal, :precision => 10, :scale => 2
  end
end

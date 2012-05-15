class RemovePledgeLiquidationsPledgeParcelId < ActiveRecord::Migration
  def change
    remove_column :pledge_liquidations, :pledge_parcel_id
  end
end

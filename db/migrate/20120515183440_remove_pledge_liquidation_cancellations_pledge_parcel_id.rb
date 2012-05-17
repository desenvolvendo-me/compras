class RemovePledgeLiquidationCancellationsPledgeParcelId < ActiveRecord::Migration
  def change
    remove_column :pledge_liquidation_cancellations, :pledge_parcel_id
  end
end

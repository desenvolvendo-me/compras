class RemovePledgeCancellationsPledgeParcelId < ActiveRecord::Migration
  def change
    remove_column :pledge_cancellations, :pledge_parcel_id
  end
end

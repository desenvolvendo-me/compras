class RemoveKindFromPledgeLiquidationCancellations < ActiveRecord::Migration
  def change
    remove_column :pledge_liquidation_cancellations, :kind
  end
end

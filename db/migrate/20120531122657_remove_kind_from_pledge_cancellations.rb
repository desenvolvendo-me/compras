class RemoveKindFromPledgeCancellations < ActiveRecord::Migration
  def change
    remove_column :pledge_cancellations, :kind
  end
end

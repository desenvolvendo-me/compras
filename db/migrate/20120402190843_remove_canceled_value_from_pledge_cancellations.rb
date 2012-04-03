class RemoveCanceledValueFromPledgeCancellations < ActiveRecord::Migration
  def up
    remove_column :pledge_cancellations, :value_canceled
  end
end

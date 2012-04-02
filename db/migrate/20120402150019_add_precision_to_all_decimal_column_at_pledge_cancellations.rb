class AddPrecisionToAllDecimalColumnAtPledgeCancellations < ActiveRecord::Migration
  def change
    change_column :pledge_cancellations, :value_canceled, :decimal, :precision => 10, :scale => 2
    change_column :pledge_cancellations, :value, :decimal, :precision => 10, :scale => 2
  end
end

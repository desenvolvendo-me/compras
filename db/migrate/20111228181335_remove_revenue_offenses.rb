class RemoveRevenueOffenses < ActiveRecord::Migration
  def change
    drop_table :revenue_offenses
  end
end

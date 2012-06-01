class RemoveEntityIdAndYearFromPledgeCancellations < ActiveRecord::Migration
  def change
    change_table :pledge_cancellations do |t|
      t.remove :entity_id
      t.remove :year
    end
  end
end

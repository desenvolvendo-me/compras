class RemoveEntityAndYearFromPledgeLiquidationCancellation < ActiveRecord::Migration
  def change
    change_table :pledge_liquidation_cancellations do |t|
      t.remove :entity_id
      t.remove :year
    end
  end
end

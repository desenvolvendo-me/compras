class RemoveEntityAndYearFromPledgeLiquidation < ActiveRecord::Migration
  def change
    change_table :pledge_liquidations do |t|
      t.remove :entity_id
      t.remove :year
    end
  end
end

class RemoveKindFromPledgeLiquidations < ActiveRecord::Migration
  def change
    remove_column :pledge_liquidations, :kind
  end
end

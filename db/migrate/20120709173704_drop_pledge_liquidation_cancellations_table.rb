class DropPledgeLiquidationCancellationsTable < ActiveRecord::Migration
  def change
    drop_table :compras_pledge_liquidation_cancellations
  end
end

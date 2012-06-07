class DropSubpledgeCancellationsTable < ActiveRecord::Migration
  def change
    drop_table :subpledge_cancellations
  end
end

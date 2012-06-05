class RemoveColumnPeriodEndFromIndexerValues < ActiveRecord::Migration
  def change
    remove_column :indexer_values, :period_end
  end
end

class RenamePeriodStartToDateOnIndexerValues < ActiveRecord::Migration
  def change
    rename_column :indexer_values, :period_start, :date
  end
end

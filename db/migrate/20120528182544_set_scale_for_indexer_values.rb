class SetScaleForIndexerValues < ActiveRecord::Migration
  def change
    change_column :indexer_values, :value, :decimal, :precision => 14, :scale => 6
  end
end

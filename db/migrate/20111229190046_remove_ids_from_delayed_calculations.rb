class RemoveIdsFromDelayedCalculations < ActiveRecord::Migration
  def change
    remove_column :delayed_calculations, :ids
  end
end

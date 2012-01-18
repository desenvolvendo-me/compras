class RemoveAttributesFromIndexers < ActiveRecord::Migration
  def change
    remove_column :indexers, :period_start
    remove_column :indexers, :period_end
    remove_column :indexers, :value
  end
end

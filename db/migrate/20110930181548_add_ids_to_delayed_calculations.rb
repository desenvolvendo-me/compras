class AddIdsToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :ids, :string
  end
end

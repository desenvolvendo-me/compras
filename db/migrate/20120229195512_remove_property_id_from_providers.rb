class RemovePropertyIdFromProviders < ActiveRecord::Migration
  def change
    remove_column :providers, :property_id
  end
end

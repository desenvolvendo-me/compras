class RemoveConfigurationFromSplittings < ActiveRecord::Migration
  def change
    remove_column :splittings, :configuration
  end
end

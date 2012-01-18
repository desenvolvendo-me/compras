class RemoveDefaultFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :default
  end
end

class RemoveCodeFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :code
  end
end

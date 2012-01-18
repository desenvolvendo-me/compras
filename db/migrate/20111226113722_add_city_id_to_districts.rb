class AddCityIdToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :city_id, :integer
    add_foreign_key :districts, :cities
  end
end

class AlterColumnDigitToCodeOnCities < ActiveRecord::Migration
  def change
    rename_column :cities, :digit, :code
  end
end
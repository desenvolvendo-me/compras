class CreateUnicoCountries < ActiveRecord::Migration
  def change
    rename_table :countries, :unico_countries
  end
end

class CreateUnicoCities < ActiveRecord::Migration
  def change
    rename_table :cities, :unico_cities
  end
end

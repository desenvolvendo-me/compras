class CreateUnicoDistricts < ActiveRecord::Migration
  def change
    rename_table :districts, :unico_districts
  end
end

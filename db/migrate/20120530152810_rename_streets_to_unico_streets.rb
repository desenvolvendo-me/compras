class RenameStreetsToUnicoStreets < ActiveRecord::Migration
  def change
    rename_table :streets, :unico_streets
  end
end

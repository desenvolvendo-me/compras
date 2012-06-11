class RenameStreetTypesToUnicoStreetTypes < ActiveRecord::Migration
  def change
    rename_table :street_types, :unico_street_types
  end
end

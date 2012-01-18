class RenameTableToModelOnFieldCalculations < ActiveRecord::Migration
  def change
    rename_column :field_calculations, :table, :model
  end
end

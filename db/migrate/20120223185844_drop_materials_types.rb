class DropMaterialsTypes < ActiveRecord::Migration
  def change
    drop_table :materials_types
  end
end

class RemoveStnOrdinanceFromMaterials < ActiveRecord::Migration
  def change
    remove_column :materials, :stn_ordinance
  end
end

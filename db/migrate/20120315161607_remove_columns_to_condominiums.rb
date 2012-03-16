class RemoveColumnsToCondominiums < ActiveRecord::Migration
  def change
    remove_column :condominiums, :quantity_garages
    remove_column :condominiums, :quantity_units
    remove_column :condominiums, :quantity_blocks
    remove_column :condominiums, :quantity_elevators
    remove_column :condominiums, :quantity_rooms
    remove_column :condominiums, :quantity_floors
    remove_column :condominiums, :built_area
    remove_column :condominiums, :area_common_user
    remove_column :condominiums, :construction_year
  end
end

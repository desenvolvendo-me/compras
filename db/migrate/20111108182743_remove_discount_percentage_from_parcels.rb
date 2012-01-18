class RemoveDiscountPercentageFromParcels < ActiveRecord::Migration
  def change
    remove_column :parcels, :discount_percentage
  end
end

class AddIndexOnRevenueIdOnParcelsRevenues < ActiveRecord::Migration
  def change
    add_index :parcels_revenues, :revenue_id
  end
end

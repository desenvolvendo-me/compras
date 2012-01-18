class AddDiscountPercentageToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :discount_percentage, :decimal, :precision => 5, :scale => 2
  end
end

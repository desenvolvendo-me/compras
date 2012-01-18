class AddPropertyRangeToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :property_range, :string
  end
end

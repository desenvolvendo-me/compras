class AddIndexOnRevenueIdOnDelayedCalculations < ActiveRecord::Migration
  def change
    add_index :delayed_calculations, :revenue_id
  end
end

class AddIndexOnRevenueIdOnFieldCalculationsRevenues < ActiveRecord::Migration
  def change
    add_index :field_calculations_revenues, :revenue_id
  end
end

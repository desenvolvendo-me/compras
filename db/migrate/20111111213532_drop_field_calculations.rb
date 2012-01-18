class DropFieldCalculations < ActiveRecord::Migration
  def change
    drop_table :field_calculations
  end
end

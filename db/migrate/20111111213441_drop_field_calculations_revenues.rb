class DropFieldCalculationsRevenues < ActiveRecord::Migration
  def change
    drop_table :field_calculations_revenues
  end
end

class AddUnitValueToItemCostImprovements < ActiveRecord::Migration
  def change
    add_column :item_cost_improvements, :unit_value, :decimal, :precision => 10, :scale => 2
  end
end

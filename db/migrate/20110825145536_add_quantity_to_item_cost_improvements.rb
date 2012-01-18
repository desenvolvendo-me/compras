class AddQuantityToItemCostImprovements < ActiveRecord::Migration
  def change
    add_column :item_cost_improvements, :quantity, :decimal, :precision => 10, :scale => 2
  end
end

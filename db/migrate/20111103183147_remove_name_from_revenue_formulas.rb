class RemoveNameFromRevenueFormulas < ActiveRecord::Migration
  def change
    remove_column :revenue_formulas, :name
  end
end

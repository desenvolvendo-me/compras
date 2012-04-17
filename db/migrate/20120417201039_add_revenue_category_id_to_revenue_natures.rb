class AddRevenueCategoryIdToRevenueNatures < ActiveRecord::Migration
  def change
    add_column :revenue_natures, :revenue_category_id, :integer
    add_index :revenue_natures, :revenue_category_id, :name => 'index_revenue_natures_on_r_category_id'
    add_foreign_key :revenue_natures, :revenue_categories
  end
end

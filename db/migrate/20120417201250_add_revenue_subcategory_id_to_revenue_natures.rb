class AddRevenueSubcategoryIdToRevenueNatures < ActiveRecord::Migration
  def change
    add_column :revenue_natures, :revenue_subcategory_id, :integer
    add_index :revenue_natures, :revenue_subcategory_id
    add_foreign_key :revenue_natures, :revenue_subcategories
  end
end

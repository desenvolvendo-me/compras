class RenameRevenueNaturesToRevenueSubcategories < ActiveRecord::Migration
  def change
    rename_table :revenue_natures, :revenue_subcategories

    rename_column :revenue_sources, :revenue_nature_id, :revenue_subcategory_id
  end
end

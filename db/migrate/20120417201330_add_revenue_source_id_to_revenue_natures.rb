class AddRevenueSourceIdToRevenueNatures < ActiveRecord::Migration
  def change
    add_column :revenue_natures, :revenue_source_id, :integer
    add_index :revenue_natures, :revenue_source_id
    add_foreign_key :revenue_natures, :revenue_sources
  end
end

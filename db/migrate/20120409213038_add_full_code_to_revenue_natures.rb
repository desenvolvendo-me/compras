class AddFullCodeToRevenueNatures < ActiveRecord::Migration
  def change
    add_column :revenue_natures, :full_code, :string
  end
end

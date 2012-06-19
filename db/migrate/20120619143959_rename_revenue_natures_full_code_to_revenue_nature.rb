class RenameRevenueNaturesFullCodeToRevenueNature < ActiveRecord::Migration
  def change
    rename_column :compras_revenue_natures, :full_code, :revenue_nature
  end
end

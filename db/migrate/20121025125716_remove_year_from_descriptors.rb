class RemoveYearFromDescriptors < ActiveRecord::Migration
  def change
    remove_column :compras_descriptors, :year
  end
end

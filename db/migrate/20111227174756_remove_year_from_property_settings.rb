class RemoveYearFromPropertySettings < ActiveRecord::Migration
  def change
    remove_column :property_settings, :year
  end
end

class RemoveDefaultFlagFromDistricts < ActiveRecord::Migration
  def change
    remove_column :districts, :default
  end
end

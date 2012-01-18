class RemoveDefaultFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :default
  end
end

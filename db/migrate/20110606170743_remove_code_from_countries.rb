class RemoveCodeFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :code
  end
end

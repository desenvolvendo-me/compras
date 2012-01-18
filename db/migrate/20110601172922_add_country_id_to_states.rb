class AddCountryIdToStates < ActiveRecord::Migration
  def change
    add_column :states, :country_id, :integer
    add_foreign_key :states, :countries
  end
end

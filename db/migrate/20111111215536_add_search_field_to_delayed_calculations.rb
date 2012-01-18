class AddSearchFieldToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :search_field, :string
  end
end

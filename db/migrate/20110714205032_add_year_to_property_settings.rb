class AddYearToPropertySettings < ActiveRecord::Migration
  def change
    add_column :property_settings, :year, :string
  end
end

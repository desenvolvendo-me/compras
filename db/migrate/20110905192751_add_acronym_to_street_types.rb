class AddAcronymToStreetTypes < ActiveRecord::Migration
  def change
    add_column :street_types, :acronym, :string
  end
end

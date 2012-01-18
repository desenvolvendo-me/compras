class AddDescriptionToUrbanServices < ActiveRecord::Migration
  def change
    add_column :urban_services, :description, :text
  end
end

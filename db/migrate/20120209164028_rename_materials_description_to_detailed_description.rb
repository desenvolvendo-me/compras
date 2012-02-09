class RenameMaterialsDescriptionToDetailedDescription < ActiveRecord::Migration
  def change
    rename_column :materials, :description, :detailed_description
  end
end

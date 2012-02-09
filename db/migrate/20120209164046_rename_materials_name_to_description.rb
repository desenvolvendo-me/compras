class RenameMaterialsNameToDescription < ActiveRecord::Migration
  def change
    rename_column :materials, :name, :description
  end
end

class RenameOrganogramsNameToDescription < ActiveRecord::Migration
  def change
    rename_column :organograms, :name, :description
  end
end

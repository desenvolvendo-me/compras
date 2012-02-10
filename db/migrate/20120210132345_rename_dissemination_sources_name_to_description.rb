class RenameDisseminationSourcesNameToDescription < ActiveRecord::Migration
  def change
    rename_column :dissemination_sources, :name, :description
  end
end

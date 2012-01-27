class RenameDisseminationSourcesDescriptionToName < ActiveRecord::Migration
  def change
    rename_column :dissemination_sources, :description, :name
  end
end

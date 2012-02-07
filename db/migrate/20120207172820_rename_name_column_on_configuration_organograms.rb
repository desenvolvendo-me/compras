class RenameNameColumnOnConfigurationOrganograms < ActiveRecord::Migration
  def change
    rename_column :configuration_organograms, :name, :description
  end
end

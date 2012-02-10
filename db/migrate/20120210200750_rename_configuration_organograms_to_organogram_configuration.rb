class RenameConfigurationOrganogramsToOrganogramConfiguration < ActiveRecord::Migration
  def change
    rename_table :configuration_organograms, :organogram_configurations
  end
end

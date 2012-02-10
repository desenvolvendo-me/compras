class RenameOrganogramLevelsConfigurationOrganogramToOrganogramConfiguration < ActiveRecord::Migration
  def change
    rename_column :organogram_levels, :configuration_organogram_id, :organogram_configuration_id
  end
end

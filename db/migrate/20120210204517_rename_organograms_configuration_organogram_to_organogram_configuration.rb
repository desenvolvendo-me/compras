class RenameOrganogramsConfigurationOrganogramToOrganogramConfiguration < ActiveRecord::Migration
  def change
    rename_column :organograms, :configuration_organogram_id, :organogram_configuration_id
  end
end

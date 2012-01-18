class RemoveColumnPropertySettingsUseSectionStreet < ActiveRecord::Migration
  def change
    remove_column :property_settings, :use_section_street
  end
end

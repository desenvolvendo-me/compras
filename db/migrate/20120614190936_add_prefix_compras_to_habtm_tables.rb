class AddPrefixComprasToHabtmTables < ActiveRecord::Migration
  def change
    rename_table :compras_bookmarks_links, :compras_bookmarks_compras_links
    rename_table :compras_dissemination_sources_regulatory_acts, :compras_dissemination_sources_compras_regulatory_acts
    rename_table :compras_document_types_licitation_processes, :compras_document_types_compras_licitation_processes
    rename_table :compras_licitation_objects_materials, :compras_licitation_objects_compras_materials
    rename_table :compras_materials_providers, :compras_materials_compras_providers
    rename_table :compras_materials_classes_providers, :compras_materials_classes_compras_providers
    rename_table :compras_materials_groups_providers, :compras_materials_groups_compras_providers
  end
end

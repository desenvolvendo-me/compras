class ChangeHabtmOfComprasDocumentTypesComprasLicitationProcessesToComprasLicitationProcessesUnicoDocumentTypes < ActiveRecord::Migration
  def change
    rename_table :compras_document_types_compras_licitation_processes, :compras_licitation_processes_unico_document_types
    remove_column :compras_licitation_processes_unico_document_types, :document_type_id
    add_column :compras_licitation_processes_unico_document_types, :document_type_id, :integer

    add_index :compras_licitation_processes_unico_document_types, :document_type_id, name: :clpudy_document_type__id
    add_foreign_key :compras_licitation_processes_unico_document_types, :unico_document_types,
                    column: :document_type_id, name: :clpudy_document_type_fk
  end
end
